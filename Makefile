files := $(shell find $(CURDIR) \
	-mindepth 1 -maxdepth 1 \
	-not -name dotfiles-install \
	-not -name dotfiles-submodules-update \
	-not -name Makefile \
	-not -name .git \
	)

define InstallFile
	[ -e $2 ] && [ ! "$1" = "$(shell readlink $2)" ] && { echo mv $2 $2.bak; }; \
	echo "ln -sf $1 $2";
endef

all: install

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))

update:
	git submodule init && \
	git submodule sync && \
	git submodule update && \
	git submodule foreach git fetch && \
	git submodule foreach git reset --hard origin/master
