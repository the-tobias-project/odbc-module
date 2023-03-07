#!/usr/bin/env bash

set -e

# ----------------------------------------------------------------------------------------------
# This script will generate the module creating the content for the following two main folders:
## /user/open/databricks-odbc
## modules/contrib/databricks-odbc
# ----------------------------------------------------------------------------------------------

check=$1

THISPATH=${PWD}
R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2

## Needed to unload any R version in this step
cd driver
module unload R

## Run code checks

### Here, checking that the md5sum provided is matching for unixODBC
if [ "$check" == "true" ]; then
    md5sum -c unixODBC-2.3.11.tar.gz.md5 | tee /dev/tty | grep "FAILED" && echo "MD5SUM DOES NOT MATCH FOR uninxODBC" && exit 1
fi

### Here, checking that the md5sum provided is matching for simbaspark. At least for this version, it wasn't the case
if [ "$check" == "true" ]; then
    echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" > shasum
    sha256sum -c shasum | tee /dev/tty | grep "FAILED" && echo "MD5SUM DOES NOT MATCH FOR SimbaSparkODBC" && exit 1
fi

## install unixODBC
### We need to install unixODBC (2.3.11) because the version available at the cluster level does not work
### with the simbaspark driver (the databricks driver)
tar xvf unixODBC-2.3.11.tar.gz
cd unixODBC-2.3.11/
./configure && make

## Install SimbaSpark
cd ${THISPATH}/driver
unzip SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rpm2cpio simbaspark-2.6.29.1049-1.x86_64.rpm | cpio -idmv
rm opt/simba/spark/lib/64/simba.sparkodbc.ini
rsync -av --ignore-existing opt/simba/ ${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/
rm -rf docs opt simbaspark-2.6.29.1049-1.x86_64.rpm

## install custom R package required to connect with Databricks and dependencies in custom library, set .Renviron
module use --append "${THISPATH}/software/modules/contribs"
module load R/4.2.0
module load unixodbc/2.3.9

R --vanilla <<EOF
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive=TRUE)
.libPaths(Sys.getenv("R_LIBS_USER"))  
install.packages(c('DBI', 'odbc', 'dotenv'), repos='http://cran.us.r-project.org', lib=Sys.getenv("R_LIBS_USER"))
EOF

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"

echo "Databricks modules succesfully installed!"