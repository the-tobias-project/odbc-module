DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell dirname $(shell pwd)))
verbose := true

uninstall:
	git reset --hard
	git clean -fdx

install: uninstall
	. $(DIR)/scripts/install_drivers.sh $(DIR) $(check) 
	. $(DIR)/scripts/install_R_dependencies.sh $(DIR) 

configure:
	. $(DIR)/scripts/configure.sh $(DIR)

setenv:
	. $(DIR)/scripts/setenv.sh $(DIR)

#get_token:
#    . $(DIR)/scripts/authorize.sh

#authorize: get_token setenv

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
    @[ $(verbose) == true ] && echo -e "\nYou can now remove this directory and, if the module was installed at group level, the folder at: $(DIR)"

.PHONY: configure install clean