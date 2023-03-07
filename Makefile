DIR := ${CURDIR}
check := true
group := false
installdir := /home/groups$(if $(group), /$(id -ng), $(shell pwd))

install:
	. $(DIR)/scripts/install.sh $(check)

configure:
	. $(DIR)/scripts/configure.sh $(installdir)

clean:
	@rm -rf ~/.env
	@sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > tmp_bashrc && mv tmp_bashrc ~/.bashrc
	@echo -e "\nYou can remove now this directory and, if the module was installed at group level, the folder at $(installdir)"

.PHONY: configure install clean
default: configure