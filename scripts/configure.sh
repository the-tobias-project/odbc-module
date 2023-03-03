#!/usr/bin/env bash

set -e

## The goal of this script is to create a .env file with all the paths
export THISPATH=${PWD}

cat > ~/.env <<EOF  
#[DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=

EOF

cat >> ~/.env <<EOF  
#[ENVIRONMENTAL VARIABLES]
ODBCSYSINI=${THISPATH}
ODBCINI=${THISPATH}/odbc.ini
MODULEPATH=$MODULEPATH:${THISPATH}/software/modules/
RLIB=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
SPARKPATH=${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark
EOF

echo "#ODBC CONFIGURATION>>>>\n for elem in $(grep -v "#" < ~/.env); do export ${elem}; done\n#<<<<ODBC CONFIGURATION" >> ~/.bashrc
echo "Done"
echo "Pease fill in the .env file at $HOME/.env with the Databricks variables and then run: make install"