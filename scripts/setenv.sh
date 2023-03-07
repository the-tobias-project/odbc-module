#!/usr/bin/env bash

set -e

export THISPATH=${PWD}

## Fill in fields corresponding to installed files in .env
envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "${THISPATH}/odbc.ini"
envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "${THISPATH}/odbcinst.ini"
envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"