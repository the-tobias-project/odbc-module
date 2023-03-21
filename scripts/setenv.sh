#!/usr/bin/env bash

set -e

export THISPATH=$1

envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "${HOME}/.odbc.ini"
envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "${HOME}/.odbcinst.ini"

