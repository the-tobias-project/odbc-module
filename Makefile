DIR := ${CURDIR}
check := true
group := false
verbose := true
stdin := true

install: clean reset
	@echo "Installing at $(DIR)"
	. $(DIR)/scripts/install_drivers.sh $(DIR) $(check) 
	. $(DIR)/scripts/install_R_dependencies.sh $(DIR) 

partial_configure:
	. $(DIR)/scripts/configure.sh $(DIR) $(stdin)

setenv:
	. $(DIR)/scripts/setenv.sh $(DIR)

authorize:
	. $(DIR)/scripts/authorize.sh

get_databricks:
	. $(DIR)/scripts/install_databricks_cli.sh 
	
get_azure:
	. $(DIR)/scripts/install_azure_cli.sh 

configure: partial_configure authorize

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
	@if command -v az > /dev/null; then az logout || echo "No accounts logged in azure"; fi

reset:
	@git reset --hard
	@git clean -fdx

uninstall: clean reset
	@echo "You can remove now this folder" 

.PHONY: configure install clean uninstall