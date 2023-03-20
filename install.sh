#!/usr/bin/env bash

set -e

while [ "$group" == "false" ]; do
    echo "Select an option:"
    echo "1) Personal"
    echo "2) Group"

    read option

    case $option in
        1)
            echo "Installing in your personal folder..."
            group=false
            ;;
        2)
            echo "Installing in group folder..."
            group=true
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

git clone https://github.com/the-tobias-project/odbc-module
cd odbc-module
git checkout devel

make install check=false group="${group}"
make configure group="${group}"

echo "All done!"



