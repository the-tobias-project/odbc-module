#!/usr/bin/env bash

set -eo pipefail

YELLOW='\033[1;33m'
NC='\033[0m' 

while true; do

    echo -e "\nSelect an install option:"
    echo -e "--------------------------\n"
    echo -e "${YELLOW}1) Personal${NC}"
    echo -e "${YELLOW}2) Group${NC}"
    printf "Your option: "

    read -r option </dev/tty
    
    set +e
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
    set -e
done

git clone https://github.com/the-tobias-project/odbc-module
cd odbc-module
git checkout devel

if [ "$install" == "true" ]; then
    make install check=false group="${group}"
fi

if [ "$configure" == "true" ]; then
    make configure group="${group}"
fi

echo -e "${YELLOW}Module successfully installed!${NC}"



