#!/bin/bash

set -e

export THISPATH=$PWD
export SPARKPATH=${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark
cd driver
module unload R
eval "$(direnv hook bash)"
direnv allow

### install unixODBC

md5sum -c unixODBC-2.3.11.tar.gz.md5 | tee /dev/tty | grep "FAILED" && echo "MD5SUM DOES NOT MATCH FOR uninxODBC" && exit 1
tar xvf unixODBC-2.3.11.tar.gz
cd unixODBC-2.3.11/
./configure && make
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${THISPATH}/driver/unixODBC-2.3.11/DriverManager/.libs" >> ~/.env
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${THISPATH}/driver/unixODBC-2.3.11/odbcinst/.libs" >> ~/.env
cd $THISPATH/driver

### Install SimbaSpark

echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" > shasum
sha256sum -c shasum | tee /dev/tty | grep "FAILED" && echo "MD5SUM DOES NOT MATCH FOR SimbaSparkODBC" && exit 1
unzip SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rpm2cpio simbaspark-2.6.29.1049-1.x86_64.rpm | cpio -idmv
rm opt/simba/spark/lib/64/simba.sparkodbc.ini
rsync -av --ignore-existing opt/simba/ $THISPATH/software/user/open/databricks-odbc/4.2.0/simba/
rm -rf docs opt simbaspark-2.6.29.1049-1.x86_64.rpm


envsubst < "$THISPATH/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
envsubst < "$THISPATH/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
envsubst < "$SPARKPATH/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "$SPARKPATH/lib/64/simba.sparkodbc.ini"
module use --append "$THISPATH/software/modules/contribs"

### install R package 

module load R/4.2.0
module load unixodbc/2.3.9

R --vanilla <<EOF
dir.create(Sys.getenv("RLIB"), showWarnings = FALSE, recursive=TRUE)
.libPaths(Sys.getenv("RLIB"))  
install.packages(c('DBI', 'odbc', 'dotenv'), repos='http://cran.us.r-project.org', lib=Sys.getenv("RLIB"))
q()
EOF



git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL loaddatabricks*.tar.gz
rm -rf loaddatabricks*


echo "Databricks modules succesfully installed!"