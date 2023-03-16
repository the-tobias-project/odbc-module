#!/usr/bin/env bash

set -e

THISPATH=$1
export R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2

mkdir -p ${R_LIBS_USER}

module unload R
module load R/4.2.0
module load unixodbc/2.3.9

declare -a packages=("odbc_1.3.4" "DBI_1.1.3" "dotenv_1.0" "rlang_1.1.0")
for package in for i in "${packages[@]}";do
    curl -L https://packagemanager.rstudio.com/cran/__linux__/centos7/latest/src/contrib/${package}.tar.gz?r_version=4.2  | tar xvz -C ${R_LIBS_USER}
done

#Rscript ${THISPATH}/scripts/dependencies.R

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

echo "R modules succesfully installed!"