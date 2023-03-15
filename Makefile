DIR := ${CURDIR}
check := true
group := false
installdir := $(if $(filter $(group),true),/home/groups/$(shell id -ng),$(shell dirname $(shell pwd)))
verbose := true
run_command := $(preinstall)


pre:
    ifneq ($(run_command),)
        $(run_command)
    endif

uninstall:
	git reset --hard
	git clean -fdx

install: uninstall pre
	. $(DIR)/scripts/install_drivers.sh $(check) $(DIR)
	. $(DIR)/scripts/install_R_dependencies.sh $(DIR)

configure:
	. $(DIR)/scripts/configure.sh $(installdir)

setenv:
	. $(DIR)/scripts/setenv.sh $(installdir)

clean:
	@rm -f ${HOME}/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ${HOME}/.bashrc
	@rm -f ${HOME}/.odbc.ini ${HOME}/.odbcinst.ini
    @[ $(verbose) == true ] && echo -e "\nYou can now remove this directory and, if the module was installed at group level, the folder at: $(installdir)"


.PHONY: configure install clean