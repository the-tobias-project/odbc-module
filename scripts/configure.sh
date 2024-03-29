#!/usr/bin/env bash

set -eo pipefail

## The goal of this script is to create a .env file with all the paths, and the odbc.ini/odbcinst.ini files


export THISPATH=$1
stdin=$2

YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' 

function setfiles() {
databricks_hostname=${1:-""}
databricks_path=${2:-""}
databricks_port=${3:-""}

echo -e "\nGenerating ${HOME}/.env"

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
MODULEPATH=${THISPATH}/software/modules/contribs:${MODULEPATH}
R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
SPARKPATH=${THISPATH}/software/user/open/databricks-odbc/4.2.0/simba/spark
LD_LIBRARY_PATH=${THISPATH}/driver/unixODBC-2.3.11/DriverManager/.libs:${THISPATH}/driver/unixODBC-2.3.11/odbcinst/.libs:${LD_LIBRARY_PATH}
EOF

echo -e "\n{YELLOW}The following lines will be aded to ${HOME}/.bashrc:{NC}"
echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs)\n#<<<<ODBC CONFIGURATION" 
echo -e "\n#ODBC CONFIGURATION>>>>\nexport \$(grep -v '^#' ${HOME}/.env | xargs)\n#<<<<ODBC CONFIGURATION" >> "${HOME}/.bashrc"
}

function printconfig() {
    echo -e "\n\n-----------------------------------------------------------------------"
    echo -e "This is the resulting configuration of the driver, check that it is correct:"
    echo -e "${PURPLE}\n-- ~/.odbc.ini ---${NC}"
    var=$(< "${HOME}/.odbc.ini")
    echo -e "${YELLOW}$var${NC}"
    echo -e "\n-----------------------------------------------------------------------\n\n"
}

if [ "$stdin" == "true" ]; then
    while true; do
        echo -e "\n\n${PURPLE}CONFIGURATION : ---------------------------------------------${NC}"
        read -p "Databricks hostname (eg, adb-xxxxxxxxxx.2.azuredatabricks.net): " databricks_hostname </dev/tty
        read -p "Databricks http path (eg, sql/protocolv1/o/123456789/1234-12345-abcde): " databricks_path </dev/tty
        read -p "Databricks port (default: 443, press enter to use default): " databricks_port </dev/tty
        echo -e "${PURPLE}------------------------------------------------------------------${NC}"
        databricks_port=${databricks_port:-443}

        setfiles "${databricks_hostname}" "${databricks_path}" "${databricks_port}"
        export $(grep -v '^#' ${HOME}/.env | xargs)
        envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "${HOME}/.odbc.ini"
        envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "${HOME}/.odbcinst.ini"
        printconfig
        printf "%b" "${YELLOW}" "Does your configuration look correct? (y/n): " "${NC}"
        read -r yn </dev/tty
        case $yn in
            [Yy]* ) echo "Success!"; exit 0;;
            [Nn]* ) continue;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

if [ "$stdin" == "false" ]; then
    setfiles
    export $(grep -v '^#' ${HOME}/.env | xargs)
    envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbc.ini" > "${HOME}/.odbc.ini"
    envsubst < "${THISPATH}/software/user/open/databricks-odbc/4.2.0/conf/odbcinst.ini" > "${HOME}/.odbcinst.ini"
    printconfig
fi
    
