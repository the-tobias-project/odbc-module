#!/usr/bin/env bash

# # Written by Leandro Roser for Stanford University

set -e

YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' 
option=""

function printfcol () {
 printf '%b' "$1" "$2" "${NC}"
}


while true; do
    echo -e "\nSelect an  option:"
    printfcol "${PURPLE}" "-------------------------\n"
    printfcol "${YELLOW}" "1 <- Install in personal folder\n"
    printfcol "${YELLOW}" "2 <- Install in group folder\n"
    printfcol "${YELLOW}" "3 <- Configure your personal folder after a group install\n"
    printfcol "${PURPLE}" "Your option: "

    read -r option </dev/tty
    
    case $option in
        1)
            printfcol "${YELLOW}" "\n\nInstalling and configuring in your personal folder...\n"
            group=false
            basepath="${HOME}"
            break
            ;;
        2)
            printfcol "${YELLOW}" "\n\nInstalling in group folder...\n"
            group=true
            groupfol="/home/groups/$(id -ng)"
            echo "Switching to $groupfol"
            basepath="$groupfol"
            cd "${basepath}"
            break
            ;;
        3) 
            printfcol "${YELLOW}" "\n\nConfiguring your personal folder for a group installation...\n"
            group=true
            break
            ;;
        *)
            printfcol "${YELLOW}" "\n\nInvalid option. Please select 1, 2, 3 or 4.\n"
            ;;
    esac
done


mkdir odbc-module-tmp && curl -L  https://github.com/the-tobias-project/odbc-module/releases/download/v1.1.0/odbc-centos7-R_4.2.0-devtoolset_10-unixodbc_2.3.9.tar.gz |  tar -xvz -C odbc-module-tmp/
mv odbc-module-tmp/home/sherlock/odbc-module/ ./odbc-module
cd odbc-module/


if [ "$option" != "3" ];then 
    while true; do
        printfcol "${PURPLE}" "\n--> Install databricks-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                make get_databricks
                echo "Databricks-cli successfully installed."
                break
                ;;
            [nN]*)
                :
                break
                ;;
            *)
                echo "Invalid input."
                ;;
            esac
    done


    while true; do
        printfcol "${PURPLE}" "\n--> Install Azure-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                make get_azure
                echo "Azure-cli successfully installed."
                break
                ;;
            [nN]*)
                :
                break
                ;;
            *)
                echo "Invalid input."
                ;;
            esac
    done
fi

while true; do
    printfcol "${PURPLE}" "\n--> Configure? (y/n): "   
    read -r config </dev/tty
    case "$config" in
        [yY]*)
            make configure group="${group}"
            printfcol "${YELLOW}" "\nAuthorizing...\n" 
            make authorize
            echo -e "Module successfully configured. To use this module reload your bash profile typing the command: ${YELLOW}. ~/.bashrc${NC}, and then load the module with: ${YELLOW}module load databricks-odbc/4.2.0${NC}"
            break
            ;;
        [nN]*)
            break
            ;;
        *)
            echo "Invalid input."
            ;;
        esac
done





