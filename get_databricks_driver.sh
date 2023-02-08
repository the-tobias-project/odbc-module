#!/bin/bash

set -e

thispath=$PWD
cd driver

echo "ce2b0e5b7f437a448cec784e2c79907b886e7cb28202d0c9d1733511b488aca2  SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip" > shasum
sha256sum -c shasum | tee >(grep "FAILED" && exit 1)
unzip SimbaSparkODBC-2.6.29.1049-LinuxRPM-64bit.zip
rpm2cpio simbaspark-2.6.29.1049-1.x86_64.rpm |  cpio -idmv
rm opt/simba/spark/lib/64/simba.sparkodbc.ini
rsync -av opt/simba/ $thispath/software/user/open/databricks-odbc/4.2.0/simba/
rm -rf docs opt simbaspark-2.6.29.1049-1.x86_64.rpm

echo "354bbf2ae6677779b581c2c410558e65ab4b8815c0e51cd317c5b909fd6ad416  DatabricksJDBC42-2.6.32.1054.zip" > shasum
sha256sum -c shasum | tee >(grep "FAILED" && exit 1)
unzip DatabricksJDBC42-2.6.32.1054.zip
mv DatabricksJDBC42.jar $thispath/software/user/open/databricks-jdbc/4.2.0/lib 
rm -rf docs EULA.txt shasum