DIR := ${CURDIR}

configure:
        . ${DIR}/scripts/configure.sh

install: 
        direnv hook bash
        direnv allow
        . ${DIR}/scripts/install.sh
