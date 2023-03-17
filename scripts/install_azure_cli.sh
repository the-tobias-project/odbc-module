#!/usr/bin/env bash

set -e

AZURE_INSTALL_DIR=$1
curl -L https://aka.ms/InstallAzureCli | bash -s -- -y
echo "export PATH=$AZURE_INSTALL_DIR/bin:\$PATH" >> "${HOME}/.bashrc"