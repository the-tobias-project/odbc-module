#!/bin/bash

export THISPATH=$PWD

echo "Running direnv setup..."
curl -sfL https://direnv.net/install.sh | bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
mkdir -p  ~/.config/direnv
touch  ~/.config/direnv/direnv.toml

cat > ~/.config/direnv/direnv.toml <<EOF  
[whitelist]
prefix = [ "$HOME" ]
[global]
load_dotenv = true

EOF

cat > ~/.env <<EOF  
#[DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=

EOF

cat >> ~/.env <<EOF  
#[ENVIRONMENTAL VARIABLES]
ODBCSYSINI=$HOME
ODBCINI=$HOME/.odbc.ini
MODULEPATH=$MODULEPATH:$PWD/software/modules/
RLIB=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2

EOF


echo "Done"
echo "Pease fill in the .env file in $HOME/.env with the Databricks variables and then run: direnv allow"

eval "$(direnv hook bash)"