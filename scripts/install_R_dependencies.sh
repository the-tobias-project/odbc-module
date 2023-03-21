#!/usr/bin/env bash

set -eo pipefail

YELLOW='\033[1;33m'
NC='\033[0m' 

THISPATH=$1
DISTRO=centos7
R_VERSION=4.2
REPO=https://packagemanager.rstudio.com/cran/__linux__/${DISTRO}/latest/src/contrib
package=odbc_1.3.4

export R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
mkdir -p ${R_LIBS_USER}

module unload R
module load R/4.2.0
module load unixodbc/2.3.9

curl -L "${REPO}/${package}.tar.gz?r_version=${R_VERSION}" | tar xvz -C "${R_LIBS_USER}"
Rscript ${THISPATH}/scripts/dependencies.R

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

echo "R modules succesfully installed!"