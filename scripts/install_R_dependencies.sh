#!/usr/bin/env bash

set -e

THISPATH=${PWD}
R_LIBS_USER=${THISPATH}/R/x86_64-pc-linux-gnu-library/4.2
mkdir -p ${R_LIBS_USER}

module unload R
module load R/4.2.0
module load unixodbc/2.3.9

R --vanilla <<EOF
libsdir <- Sys.getenv("R_LIBS_USER")
dir.create(libsdir, showWarnings = FALSE, recursive=TRUE) 
install.packages('odbc', repos='http://cran.us.r-project.org', lib=libsdir, type="source")
install.packages(c('DBI', 'dotenv'), repos='http://cran.us.r-project.org', lib=libsdir)
EOF

git clone https://github.com/the-tobias-project/loaddatabricks
R CMD build loaddatabricks 
R CMD INSTALL -l ${R_LIBS_USER} loaddatabricks*.tar.gz
rm -rf loaddatabricks*

echo "R modules succesfully installed!"