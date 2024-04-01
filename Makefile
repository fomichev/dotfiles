files := $(shell find $(CURDIR) \
	-mindepth 1 -maxdepth 1 \
	-not -name Makefile \
	-not -name README \
	-not -name '.git' \
	-not -name '.gitignore' \
	-not -name '.gitmodules' \
	-not -name ignore \
	)

dbg := #echo

define Ignored
$(shell [ -r $(CURDIR)/ignore ] && grep -q $(shell echo "$1" | sed -e 's@$(CURDIR)/@@') $(CURDIR)/ignore && echo 1 || echo 0)
endef

define InstallFile
	[ $(call Ignored,$1) -eq 0 ] && { \
		[ -e $2 ] && \
			[ ! "$1" = "$(shell readlink $2)" ] && \
			{ $(dbg) mv $2 $2.bak; }; \
		$(dbg) rm -f "$2"; \
		$(dbg) ln -s "$1" "$2"; \
	};
endef

all: install init update

build:
	pkg/mk pkg/golang
	pkg/mk pkg/vim
	pkg/mk pkg/llvm
	pkg/mk pkg/pahole
	pkg/mk pkg/sparse
	pkg/mk pkg/nvim
	#pkg/mk pkg/neomutt
	#pkg/mk pkg/tmux

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))
	chmod 700 .gnupg
	chmod -R 700 ~/.secret

colors:
	./base16-shell/scripts/base16-eighties.sh

init:
	git submodule init && \
	git submodule sync && \
	git submodule update && \
	~/.tmux/plugins/tpm/bin/install_plugins

update:
	git submodule foreach git fetch && \
	git submodule foreach git pull && \
	~/.tmux/plugins/tpm/bin/update_plugins all

alias:
	cat ~/.bash_history | cut -d' ' -f1 | cut -d'|' -f1 | sort | uniq -c | sort -n | sort -nr
