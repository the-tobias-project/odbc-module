#!/usr/bin/env bash

set -e

export THISPATH=$1/odbc-module

envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "${HOME}/.odbc.ini"
envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "${HOME}/.odbcinst.ini"

echo -e "\n\n-----------------------------------------------------------------------"
echo -e "Done. This is the resulting configuration, check that it is correct:"
echo -e "\n\n-- ~/.odbc.ini ---"
cat "${HOME}/.odbc.ini"
echo -e "\n\n-- ~/.odbcinst.ini ---"
cat "${HOME}/.odbcinst.ini"
echo -e "\n-----------------------------------------------------------------------\n\n"