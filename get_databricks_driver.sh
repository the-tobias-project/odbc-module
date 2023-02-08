#!/bin/bash

set -e

mkdir driver
cd driver
curl -O https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-Debian-64bit.zip
unzip SimbaSparkODBC-2.6.29.1049-Debian-64bit.zip
rm -rf SimbaSparkODBC-2.6.29.1049-Debian-64bit.zip
ar vx simbaspark_2.6.29.1049-2_amd64.deb
rm -rf simbaspark_2.6.29.1049-2_amd64.deb 
tar xf control.tar.gz > /dev/null
tar xf data.tar.gz 
rm -rf control.tar.gz data.tar.gz
md5sum -c md5sums | tee >(grep "FAILED" && exit 1)
cd ..
mv driver/opt/simba/spark/lib/64/libsparkodbc_sb64.so software/user/open/databricks-odbc/4.2.0/lib/64/
rm -rf driver


mkdir driver
cd driver
curl -O https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/jdbc/2.6.32/DatabricksJDBC42-2.6.32.1054.zip
echo "354bbf2ae6677779b581c2c410558e65ab4b8815c0e51cd317c5b909fd6ad416  DatabricksJDBC42-2.6.32.1054.zip" > shasum
sha256sum -c shasum | tee >(grep "FAILED" && exit 1)
unzip DatabricksJDBC42-2.6.32.1054.zip
rm -rf DatabricksJDBC42-2.6.32.1054.zip
cd ..
mv driver/DatabricksJDBC42.jar software/user/open/databricks-jdbc/4.2.0/lib 
rm -rf driver