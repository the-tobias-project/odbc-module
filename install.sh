#!/usr/bin/env bash

set -euo pipefail

# Define colors
YELLOW='\033[1;33m'
NC='\033[0m' 

while true; do

    echo -e "${YELLOW}Select an option:${NC}"
    echo -e "${YELLOW}1) Personal${NC}"
    echo -e "${YELLOW}2) Group${NC}"

    read option </dev/tty
    set +e
    case $option in
        1)
            echo -e "${YELLOW}Installing and configuring in your personal folder...${NC}"
            group=false
            install=true
            configure=true
            break
            ;;
        2)
            echo -e "${YELLOW}Installing in group folder...${NC}"
            group=true
            install=true
            configure=false
            break
            ;;
        3) 
            echo -e "${YELLOW}Configuring your personal folder for a group installation...${NC}"
            group=true
            install=false
            configure=true
            break
            ;;
        *)
            echo -e "${YELLOW}Invalid option. Please select 1, 2 or 3.${NC}"
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

echo -e "${YELLOW}All done!${NC}"



