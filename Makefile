	DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell dirname $(shell pwd)))
verbose := true

uninstall:
	git reset --hard
	git clean -fdx

install_packages: uninstall
	. $(DIR)/scripts/install_drivers.sh $(DIR) $(check) 
	. $(DIR)/scripts/install_R_dependencies.sh $(DIR) 

configure:
	. $(DIR)/scripts/configure.sh $(DIR)

setenv:
	. $(DIR)/scripts/setenv.sh $(DIR)

authorize:
	. $(DIR)/scripts/authorize.sh
	
getaz:
	module load python/3.6.1 && \
	pip install databricks-cli && \
	curl -L https://aka.ms/InstallAzureCli | bash -s -- -y

full_install: install_packages getaz configure

full_authorize: setenv authorize

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
    @[ $(verbose) == true ] && echo -e "\nYou can now remove this directory and, if the module was installed at group level, the folder at: $(DIR)"

.PHONY: configure install clean