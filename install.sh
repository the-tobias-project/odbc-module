#!/bin/bash

bash get_databricks_driver.sh
RUN envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
RUN envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
module use --append "$PWD/software/modules/contribs"
echo "DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar" >> ~/.Renviron
echo "Databricks modules succesfully installed!"