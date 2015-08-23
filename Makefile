INSTALL_GIT=assets/install-git.sh
INSTALL_PLUGINS=assets/install-plugins.sh

all: install

install: install-git \
	install-plugins

install-git:
	$(INSTALL_GIT)

install-plugins:
	$(INSTALL_PLUGINS)
