PREFIX ?= $(CURDIR)/build/nuvim

.PHONY: all build plugins language-servers install clean

all: plugins build

build:
	./scripts/build-filc-vim.sh

plugins:
	./scripts/bootstrap-plugins.sh

language-servers:
	./scripts/install-language-servers.sh

install: all
	mkdir -p "$(DESTDIR)$(PREFIX)"
	cp -R build/nuvim/. "$(DESTDIR)$(PREFIX)/"

clean:
	rm -rf build dist
