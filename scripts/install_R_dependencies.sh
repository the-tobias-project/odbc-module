#!/usr/bin/env bash

set -e

THISPATH=$1
PARENT_DIR=$(dirname "$(readlink -f "$0")")
export R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
export PACKAGE_MANAGER="https://packagemanager.rstudio.com/cran/__linux__/centos7/latest"

mkdir -p ${R_LIBS_USER}

module unload R
module load R/4.2.0
module load unixodbc/2.3.9

Rscript ${THISPATH}/scripts/dependencies.R

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

echo "R modules succesfully installed!"