configure:
	./scripts/configure.sh

install: 
	source ~/.bashrc
	direnv allow
	./scripts/install.sh