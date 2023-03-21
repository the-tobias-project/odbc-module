#!/usr/bin/env bash

set -e

YELLOW='\033[1;33m'
NC='\033[0m' 

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
            break
            ;;
        2)
            echo -e "\n\n${YELLOW}Installing in group folder...${NC}"
            group=true
            install=true
            configure=false
            break
            ;;
        3) 
            echo -e "\n\n${YELLOW}Configuring your personal folder for a group installation...${NC}"
            group=true
            install=false
            configure=true
            break
            ;;
        *)
            echo -e "\n\n${YELLOW}Invalid option. Please select 1, 2 or 3.${NC}"
            ;;
    esac
done


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

git checkout devel


if [ "$install" == "true" ]; then
    while true; do
        printf "Install libraries and databricks-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                make install check=false group="${group}"
                make get_databricks
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
        printf "Install azure-cli? (y/n): "  
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                make get_azure
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


if [ "$install" == "true" ] && [ "$configure" == "true" ];then
    while true; do
        printf "Configure? (y/n): "   
        read -r config </dev/tty
        case "$config" in
            [yY]*)
                make configure group="${group}"
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

if [ "$install" == "false" ] && [ "$configure" == "true" ];then
    make configure group="${group}"
fi

echo "Module successfully installed. To use this module type: module load databricks-odbc/4.2.0"



