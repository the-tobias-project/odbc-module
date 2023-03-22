#!/usr/bin/env bash

# Leandro Roser, for Stanford University.

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
    printfcol "${YELLOW}" "4 <- Continue a previous installation\n"
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
            break
            ;;
        3) 
            printfcol "${YELLOW}" "\n\nConfiguring your personal folder for a group installation...\n"
            group=true
            basepath="${HOME}"
            break
            ;;
        4)
            printfcol "${YELLOW}" "\n\nContinue with previous installation...\n"
            break
            ;;
        *)
            printfcol "${YELLOW}" "\n\nInvalid option. Please select 1, 2, 3 or 4.\n"
            ;;
    esac
done


if [ "$option" == "3" ];then 
    git clone https://github.com/the-tobias-project/odbc-module
    cd  odbc-module
    git checkout devel
    make configure group="${group}"
    echo "Module successfully configured. To use this module type: module load databricks-odbc/4.2.0"
    exit 0
fi


if [ "$option" == "4" ]; then
    default="${HOME}/odbc-module"
    printfcol "${PURPLE}" "\n--> Provide the path where the odbc-module library is present (default: ${default}): "
    read -r folder </dev/tty
    folder=${folder:-$default}
    cd "$folder"
    basepath="$(dirname "$folder")"
fi

if [ "$option" == "1" ] || [ "$option" == "2" ];then 
    while true; do
        printfcol "${PURPLE}" "\n--> Download repo? (y/n): " 
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
        printfcol "${PURPLE}" "\n--> Install libraries and databricks-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                cd "${basepath}/odbc-module"
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

if [ "$option" != "3" ];then 
    while true; do
        printfcol "${PURPLE}" "\n--> Install Azure-cli? (y/n): " 
        read -r installlib </dev/tty
        case "$installlib" in
            [yY]*)
                cd "${basepath}/odbc-module"
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


if [ "$option" != "2" ];then 
    while true; do
        printfcol "${PURPLE}" "\n--> Configure? (y/n): "   
        read -r config </dev/tty
        case "$config" in
            [yY]*)
                cd "${basepath}/odbc-module"
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
fi




