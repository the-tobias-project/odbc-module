#!/usr/bin/env bash

set -e

## The goal of this script is to create a .env file with all the paths, and the odbc.ini/odbcinst.ini files

export THISPATH=$1
stdin=$2

YELLOW='\033[1;33m'
NC='\033[0m' 

function setfiles() {

cat > "${HOME}/.env" <<EOF  
#[DATABRICKS SETTINGS]
DATABRICKS_HOSTNAME=${databricks_hostname}
DATABRICKS_TOKEN=
DATABRICKS_HTTP_PATH=${databricks_path}
DATABRICKS_PORT=${databricks_port}

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

echo -e "\n\nThe following lines will be aded to ${HOME}/.bashrc:"
echo -e "{\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs);module use --append ${THISPATH}/software/modules/contribs\n#<<<<ODBC CONFIGURATION" 
echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs);module use --append ${THISPATH}/software/modules/contribs\n#<<<<ODBC CONFIGURATION" >> "${HOME}/.bashrc"
}

function printconfig() {
    echo -e "\n\n-----------------------------------------------------------------------"
    echo -e "This is the resulting configuration of the driver, check that it is correct:"
    echo -e "${YELLOW}\n\n-- ~/.odbc.ini ---${NC}"
    cat "${HOME}/.odbc.ini"
    echo -e "\n-----------------------------------------------------------------------\n\n"
}


if [ "${stdin}" = "true" ]; then
    while true; do
        echo -e "${YELLOW}CONFIGURATION : ---------------------------------------------${NC}"
        read -p "Databricks hostname (eg, adb-xxxxxxxxxx.2.azuredatabricks.net): " databricks_hostname </dev/tty
        read -p "Databricks http path (eg, sql/protocolv1/o/123456789/1234-12345-abcde): " databricks_path </dev/tty
        read -p "Databricks port (default: 443, press enter to use default): ${NC}" databricks_port </dev/tty
        databricks_port=${databricks_port:-443}

        setfiles && printconfig

        export $(grep -v '^#' ${HOME}/.env | xargs)
        . ${THISPATH}/scripts/setenv.sh ${THISPATH}

        read -p "Is your configuration correct? (y/n)" yn </dev/tty
        case $yn in
            [Yy]* ) echo "Success!"; exit 0;;
            [Nn]* ) continue;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

[ "${stdin}" = "false" ] && setfiles && printconfig && echo 0
