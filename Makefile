DIR := ${CURDIR}
check := true

.ONESHELL:
configure:
	. ${DIR}/scripts/configure.sh
	export $$(grep -v '^#' ~/.env | xargs)

install: 
	. ${DIR}/scripts/install.sh ${check}

.ONESHELL:
clean:
	@rm -rf ~/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ~/.bashrc`
	@source ~/.bashrc
	@echo -e "\nYou can remove now this directory"

.PHONY: configure install clean
default: configure