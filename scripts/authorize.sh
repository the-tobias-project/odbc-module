#!/usr/bin/env bash

set -e

# Written by Douglas Spencer for Stanford University

which az >/dev/null || echo Azure CLI not found. Please go to https://learn.microsoft.com/en-us/cli/azure/install-azure-cli and install the appropriate version

az login --use-device-code --allow-no-subscriptions

# Retrieve the AAD token from Azure
export DATABRICKS_AAD_TOKEN=$(jq .accessToken -r <<< `az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d`)

echo "Please enter the Databricks URL (starting with https://):"

read dbhost

databricks configure --aad-token --host $dbhost

DATABRICKS_PAT=$(jq .token_value -r <<< `databricks tokens create --lifetime-seconds 600 --comment "Personal Access Token"`)

sed -i "s/DATABRICKS_TOKEN=.*/DATABRICKS_TOKEN=${DATABRICKS_PAT}/" ${HOME}/.env
