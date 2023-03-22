#!/usr/bin/env bash

# Written by Douglas Spencer for Stanford University

set -eo pipefail

module load python/3.9.0

which az >/dev/null || echo Azure CLI not found. Please go to https://learn.microsoft.com/en-us/cli/azure/install-azure-cli and install the appropriate version

az login --use-device-code --allow-no-subscriptions >/dev/null

# Retrieve the AAD token from Azure
export DATABRICKS_AAD_TOKEN=$(jq .accessToken -r <<< `az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d`)

dbhost=https://$(grep "Host=" ~/.odbc.ini | cut -d "=" -f 2 | awk '{print $1}')

echo "Authorizing: $dbhost"

databricks configure --aad-token --host $dbhost >/dev/null

DATABRICKS_PAT=$(jq .token_value -r <<< `databricks tokens create --lifetime-seconds 600 --comment "Personal Access Token"`)

sed -i "s/PWD=.*/PWD=${DATABRICKS_PAT}/" "${HOME}/.odbc.ini"

echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs)\n#<<<<ODBC CONFIGURATION" >> "${HOME}/.bashrc"
echo "Done."

module unload python/3.9.0