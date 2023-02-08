#!/bin/bash

bash get_databricks_driver.sh
export THIS_LOCATION=$PWD/software/user/open/databricks-odbc/4.2.0
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
module use --append "$PWD/software/modules/contribs"
echo "export DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar" >> ~/.Renviron

echo "export ODBCSYSINI=$HOME" >> ~/.bashrc
echo "export ODBCINI=$HOME/.odbc.ini" >> ~/.bashrc
echo "Databricks modules succesfully installed!"