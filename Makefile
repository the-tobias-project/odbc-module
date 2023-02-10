DIR := ${CURDIR}
check := true

configure:
	. ${DIR}/scripts/configure.sh

install: 
	direnv hook bash
	direnv allow
	. ${DIR}/scripts/install.sh ${check}

.PHONY: default
default: configure 