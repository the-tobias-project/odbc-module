DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell dirname $(shell pwd)))
verbose := true

uninstall:
	git checkout . && git clean -fd

install: uninstall
	. $(DIR)/scripts/install.sh $(check)

configure:
	. $(DIR)/scripts/configure.sh $(installdir)

setenv:
	. $(DIR)/scripts/setenv.sh $(installdir)

clean:
	@rm -f ~/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ~/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
	if [ $(verbose) == "true" ]; do @echo -e "\nYou can now remove this directory and, if the module was installed at group level, the folder at: $(installdir)"; done

.PHONY: configure install clean