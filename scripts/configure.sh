#!/bin/bash

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
DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar
ODBCSYSINI=$HOME
ODBCINI=$HOME/.odbc.ini
MODULEPATH=$MODULEPATH:$PWD/software/modules/

EOF

echo "Done"
echo "Pease fill in the .env file in $HOME/.env with the Databricks variables and then run: direnv allow"

eval "$(direnv hook bash)"