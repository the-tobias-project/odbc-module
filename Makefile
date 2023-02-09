configure:
	./configure.sh

install: 
	source ~/.bashrc
	direnv allow
	./install.sh