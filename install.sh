#!/usr/bin/env bash

set -e

while [ "$group" == "false" ]; do
    echo "Select an option:"
    echo "1) Personal"
    echo "2) Group"

    read option

    case $option in
        1)
            echo "Installing and configuring in your personal folder..."
            group=false
            install=true
            configure=true
            ;;
        2)
            echo "Installing in group folder..."
            group=true
            install=true
            configure=false
            ;;
        3) 
            echo "Configuring your personal folder for a group installation..."
            group=true
            install=false
            configure=true
            ;;
        *)
            echo "Invalid option. Please select 1, 2 or 3."
            ;;
    esac
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

echo "All done!"



