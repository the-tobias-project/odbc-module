#!/usr/bin/env bash

set -e

## The goal of this script is to create a .env file with all the paths

export THISPATH=$1

cat > "${HOME}/.env" <<EOF  
#[DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=

EOF

cat >> "${HOME}/.env" <<EOF  
#[ENVIRONMENTAL VARIABLES] # do not modify
ODBCINI=${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini
ODBCSYSINI=${ODBCSYSINI}:${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/
MODULEPATH=${MODULEPATH}:${THISPATH}/software/modules/
R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
SPARKPATH=${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${THISPATH}/driver/unixODBC-2.3.11/DriverManager/.libs:${THISPATH}/driver/unixODBC-2.3.11/odbcinst/.libs
EOF

echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ~/.env | xargs)\n#<<<<ODBC CONFIGURATION" >> "${HOME}/.bashrc"
echo "Done"
echo "Pease fill in the .env file at ${HOME}/.env with the Databricks variables before using this module"