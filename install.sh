#!/bin/bash

bash get_databricks_driver.sh

export THIS_LOCATION=$PWD/software/user/open/databricks-odbc/4.2.0
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "$HOME/.odbc.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "$HOME/.odbcinst.ini"
envsubst < "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini" > temporal.txt
mv temporal.txt "$PWD/software/user/open/databricks-odbc/4.2.0/simba/spark/lib/64/simba.sparkodbc.ini"
module use --append "$PWD/software/modules/contribs"
echo "export DATABRICKS_JAR=$PWD/software/user/open/databricks-jdbc/4.2.0/lib/DatabricksJDBC42.jar" >> ~/.Renviron
echo "export ODBCSYSINI=$HOME" >> ~/.bashrc
echo "export ODBCINI=$HOME/.odbc.ini" >> ~/.bashrc

echo "Databricks modules succesfully installed!"

echo "Running direnv setup..."
curl -sfL https://direnv.net/install.sh | bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
mkdir -p  ~/.config/direnv
touch  ~/.config/direnv/direnv.toml

echo "# [DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=" >> ~/.env

echo "Done"
echo "Pease fill in the .env file in $HOME/.env with the Databricks variables and then run: direnv allow"