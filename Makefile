files := $(shell find $(CURDIR) \
	-mindepth 1 -maxdepth 1 \
	-not -name Makefile \
	-not -name README \
	-not -name .git \
	)

dbg := #echo

define InstallFile
	[ -e $2 ] && [ ! "$1" = "$(shell readlink $2)" ] && { $(dbg) mv $2 $2.bak; }; \
	$(dbg) rm "$2"; \
	$(dbg) ln -s "$1" "$2";
endef

all: install update

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))

update:
	git submodule init && \
	git submodule sync && \
	git submodule update && \
	git submodule foreach git fetch && \
	git submodule foreach git reset --hard origin/master
