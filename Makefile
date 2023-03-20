DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell dirname $(shell pwd)))
verbose := true

uninstall:
	git reset --hard
	git clean -fdx

install: uninstall
	. $(DIR)/scripts/install_drivers.sh $(installdir) $(check) 
	. $(DIR)/scripts/install_R_dependencies.sh $(installdir) 

configure:
	. $(DIR)/scripts/configure.sh $(installdir)

setenv:
	. $(DIR)/scripts/setenv.sh $(installdir)

authorize:
	. $(DIR)/scripts/authorize.sh
	
getaz:
	module load python/3.6.1 && \
	pip install databricks-cli && \
	curl -L https://aka.ms/InstallAzureCli | bash -s -- -y

full_install: install getaz configure

full_authorize: setenv authorize

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
    @[ $(verbose) == true ] && echo -e "\nYou can now remove this directory and, if the module was installed at group level, the folder at: $(DIR)"

.PHONY: configure install clean