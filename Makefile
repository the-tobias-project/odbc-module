DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell pwd))
verbose := true
stdin := true

uninstall:
	git reset --hard
	git clean -fdx

partial_install: uninstall
	echo "Installing at ${installdir}"
	. $(DIR)/scripts/install_drivers.sh $(installdir) $(check) 
	. $(DIR)/scripts/install_R_dependencies.sh $(installdir) 

partial_configure:
	. $(DIR)/scripts/configure.sh $(installdir) $(stdin)

setenv:
	. $(DIR)/scripts/setenv.sh $(installdir)

authorize:
	. $(DIR)/scripts/authorize.sh
	
getaz:
	module load python/3.6.1 && \
	pip install databricks-cli && \
	curl -L https://aka.ms/InstallAzureCli | bash 

install: partial_install getaz 

configure: partial_configure authorize

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
	@if command -v az > /dev/null; then az logout; fi

.PHONY: configure install clean