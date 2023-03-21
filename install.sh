#!/usr/bin/env bash

set -e

YELLOW='\033[1;33m'
NC='\033[0m' 
option=""

while true; do

    echo -e "\nSelect an install option:"
    echo -e "--------------------------\n"
    echo -e "${YELLOW}1) Personal${NC}"
    echo -e "${YELLOW}2) Group${NC}"
    printf "Your option: "

    read -r option </dev/tty
    
    case $option in
        1)
            echo -e "\n\n${YELLOW}Installing and configuring in your personal folder...${NC}"
            group=false
            install=true
            configure=true
            cd ${HOME}
            break
            ;;
        2)
            echo -e "\n\n${YELLOW}Installing in group folder...${NC}"
            group=true
            install=true
            configure=false
            cd /home/groups/$(id -ng)
            break
            ;;
        3) 
            echo -e "\n\n${YELLOW}Configuring your personal folder for a group installation...${NC}"
            group=true
            install=false
            configure=true
            cd ${HOME}
            break
            ;;
        4)
            echo -e "\n\n${YELLOW}Continue with previous installation...${NC}"
            break
            ;;
        *)
            echo -e "\n\n${YELLOW}Invalid option. Please select 1, 2 or 3.${NC}"
            ;;
    esac
done


if [ "$option" == "3" ];then 
    make configure group="${group}"
    echo "Module successfully configured. To use this module type: module load databricks-odbc/4.2.0"
    exit 0
fi


if [ "$option" == "4" ]; then;
    echo "provide the directory where the odbc-module library is present (eg, ${HOME}/odbc-module)"
    read -r $folder </dev/tty
    cd $folder
fi

if [ "$option" == "1" ] || [ "$option" == "2" ];then 
    while true; do
        printf "Download repo? (y/n): " 
        read -r repo </dev/tty
        case "$repo" in
            [yY]*)
                git clone https://github.com/the-tobias-project/odbc-module
                cd odbc-module
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
fi


git checkout devel

if [ "$option" != "3" ];then 
    while true; do
        printf "Install libraries and databricks-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                make install check=false group="${group}"
                make get_databricks
                echo "Libraries successfully installed."
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


if [ "$option" != "2" ];then 
    while true; do
        printf "Configure? (y/n): "   
        read -r config </dev/tty
        case "$config" in
            [yY]*)
                make configure group="${group}"
                echo "Module successfully configured. To use this module type: module load databricks-odbc/4.2.0"
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
fi




