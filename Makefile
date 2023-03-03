DIR := ${CURDIR}
check := true

configure:
	. ${DIR}/scripts/configure.sh
	source ~/.bashrc

install: 
	. ${DIR}/scripts/install.sh ${check}

clean:
	rm -rf ~/.env && \	
	THISPATH=${PWD} && \
	rm -rf ${THISPATH}/R && \
	rm -rf ${THISPATH}/software && \
	rm -rf ${THISPATH}/driver && \
	rm -rf ${THISPATH}/lib && \
	sed '/#ODBC CONFIGURATION>>>>/,/#<<<<ODBC CONFIGURATION/d' ~/.bashrc > ~/.bashrc && \
	$(grep -v ${RLIB} < ~/.Renviron) > ~/.Renviron && \
	source ~/.bashrc && \
	echo "You can remove this folder now"

.PHONY: configure install clean
default: configure 