#!/bin/bash

set -e

mkdir driver
cd driver
wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/odbc/2.6.29/SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" > shasum
sha256sum -c shasum | tee >(grep "FAILED" && exit 1)
unzip SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rm -rf SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rpm2cpio simbaspark-2.6.29.1049-1.x86_64.rpm |  cpio -idmv
rm -rf simbaspark-2.6.29.1049-1.x86_64.rpm
cd ..
mv driver/opt/simba/ software/user/open/databricks-odbc/4.2.0/simba
rm -rf driver


mkdir driver
cd driver
wget https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/jdbc/2.6.32/DatabricksJDBC42-2.6.32.1054.zip
echo "354bbf2ae6677779b581c2c410558e65ab4b8815c0e51cd317c5b909fd6ad416  DatabricksJDBC42-2.6.32.1054.zip" > shasum
sha256sum -c shasum | tee >(grep "FAILED" && exit 1)
unzip DatabricksJDBC42-2.6.32.1054.zip
rm -rf DatabricksJDBC42-2.6.32.1054.zip
cd ..
mv driver/DatabricksJDBC42.jar software/user/open/databricks-jdbc/4.2.0/lib 
rm -rf driver