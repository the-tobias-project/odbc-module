#!/bin/bash

bash get_databricks_driver.sh

export THIS_LOCATION=$PWD/software/user/open/databricks-odbc/4.2.0
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"
module use --append "$PWD/software/modules/contribs"

echo "Databricks modules succesfully installed!"

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

echo -e "\n\n# [DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=" >> ~/.env

echo "Done"
echo "Pease fill in the .env file in $HOME/.env with the Databricks variables and then run: direnv allow"


echo -e "\n\n [ENVIRONMENTAL VARIABLES]" >> .env
echo "DATABRICKS_JAR=$HOME/lua-modules/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar" >> .env
echo "ODBCSYSINI=$HOME" >> .env
echo "ODBCINI=$HOME/.odbc.ini" >> .env
echo "MODULEPATH=$MODULEPATH:$HOME/lua-modules/software/modules/" >> .env

eval "$(direnv hook bash)"