#!/usr/bin/env bash

set -e

THISPATH=$1
DISTRO=centos7
R_VERSION=4.2
REPO=https://packagemanager.rstudio.com/cran/__linux__/${DISTRO}/latest/src/contrib

export R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
mkdir -p ${R_LIBS_USER}

module unload R
module load R/4.2.0
module load unixodbc/2.3.9

while read -r package; do
    curl -L "${REPO}/${package}.tar.gz?r_version=${R_VERSION}" | tar xvz -C "${R_LIBS_USER}"
done < ${THISPATH}/scripts/R_requirements.txt

Rscript ${THISPATH}/scripts/dependencies.R

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

echo "R modules succesfully installed!"