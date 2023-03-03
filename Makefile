DIR := ${CURDIR}
check := true

configure:
	. ${DIR}/scripts/configure.sh
	source ~/.bashrc

install: 
	. ${DIR}/scripts/install.sh ${check}

clean:
	rm -rf ~/.env && \
	sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > ~/.bashrc && \
	$(grep -v $(RLIB) < ~/.Renviron) > ~/.Renviron && \
	rm -rf ${DIR} && \
	source ~/.bashrc && \
	echo -e "\nDone!"

.PHONY: configure install clean
default: configure 