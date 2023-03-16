#!/usr/bin/env bash

set -e

## The goal of this script is to create a .env file with all the paths

export THISPATH=$1

cat > "${HOME}/.env" <<EOF  
#[DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=
DATABRICKS_PORT=443

EOF

cat >> "${HOME}/.env" <<EOF  
#[ENVIRONMENTAL VARIABLES] # do not modify
MODULE_FOLDER=${THISPATH}
ODBCINI=${HOME}/.odbc.ini
ODBCSYSINI=${HOME}
MODULEPATH=${MODULEPATH}:${THISPATH}/software/modules/contribs
R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
SPARKPATH=${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${THISPATH}/driver/unixODBC-2.3.11/DriverManager/.libs:${THISPATH}/driver/unixODBC-2.3.11/odbcinst/.libs
EOF


echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs)\n#<<<<ODBC CONFIGURATION" >> "${HOME}/.bashrc"

echo -e "\n\n-----------------------------------------------------------------------"
echo -e "Done. This is the resulting configuration at ${HOME}/.env, check that it is correct:"
cat "${HOME}/.env"
echo -e "\n\nThe following lines were aded to ${HOME}/.bashrc:"
echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs)\n#<<<<ODBC CONFIGURATION" 
echo -e "\n-----------------------------------------------------------------------\n\n"
echo "Please fill in the .env file at ${HOME}/.env with the Databricks variables"

