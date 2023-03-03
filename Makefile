DIR := ${CURDIR}
check := true

.ONESHELL:
configure:
	. ${DIR}/scripts/configure.sh
	source ~/.bashrc

install: 
	. ${DIR}/scripts/install.sh ${check}

.ONESHELL:
clean:
	@rm -rf ~/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > ~/.bashrc
	@$(grep -v $(RLIB) < ~/.Renviron) > ~/.Renviron
	@source ~/.bashrc
	@echo -e "\nYou can remove now this directory"

.PHONY: configure install clean
default: configure