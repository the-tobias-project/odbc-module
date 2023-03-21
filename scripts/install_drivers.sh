#!/usr/bin/env bash

set -euo pipefail

YELLOW='\033[1;33m'
NC='\033[0m' 

# ----------------------------------------------------------------------------------------------
# This script will generate the module creating the content for the following two main folders:
## /user/open/databricks-odbc
## modules/contrib/databricks-odbc
# ----------------------------------------------------------------------------------------------

THISPATH=$1
check=$2

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${THISPATH}/driver/unixODBC-2.3.11/DriverManager/.libs:${THISPATH}/driver/unixODBC-2.3.11/odbcinst/.libs # this line could be unnecesary here

## Needed to unload any R version in this step
mkdir ${THISPATH}/driver
cd ${THISPATH}/driver

wget https://www.unixodbc.org/unixODBC-2.3.11.tar.gz
wget https://www.unixodbc.org/unixODBC-2.3.11.tar.gz.md5
wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip

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
cd ..
unzip SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rpm2cpio simbaspark-2.6.29.1049-1.x86_64.rpm | cpio -idmv
rm opt/simba/spark/lib/64/simba.sparkodbc.ini
rsync -av --ignore-existing opt/simba/ ${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/
rm -rf docs opt simbaspark-2.6.29.1049-1.x86_64.rpm

envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"

echo "${YELLOW}Databricks modules succesfully installed!${NC}"