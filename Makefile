DIR := ${CURDIR}
check := true

configure:
	. ${DIR}/scripts/configure.sh

setenv:
	. ${DIR}/scripts/setenv.sh

install: 
	. ${DIR}/scripts/install.sh ${check}

clean:
	@rm -rf ~/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ~/.bashrc`
	@echo -e "\nYou can remove now this directory"

.PHONY: configure install clean
default: configure