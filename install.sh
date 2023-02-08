#!/bin/bash

bash get_databricks_driver.sh

export THIS_LOCATION=$PWD/software/user/open/databricks-odbc/4.2.0
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"
module use --append "$PWD/software/modules/contribs"

echo "Databricks modules succesfully installed!"
