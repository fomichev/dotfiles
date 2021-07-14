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

GUIX_VERSION=1.3.0

guix_prepare:
	sudo mkdir /var/guix /gnu /var/log/guix /etc/guix
	sudo chown -R $(USER):$(USER) /var/guix/ /gnu /var/log/guix /etc/guix
	curl -LO https://ftp.gnu.org/gnu/guix/guix-binary-$(GUIX_VERSION).x86_64-linux.tar.xz
	tar xf guix-binary-$(GUIX_VERSION)-linux.tar.xz
	mv gnu/* /gnu/
	mv var/guix/* /var/guix/
	mkdir -p ~/.config/guix
	ln -sf /var/guix/profiles/per-user/root/current-guix /home/$(USER)/.config/guix/current
	ln -sf /var/guix/profiles/per-user/root /var/guix/profiles/per-user/$(USER)

guix_allow_prebuilt:
	guix archive --authorize < ~/.config/guix/current/share/guix/ci.guix.gnu.org.pub
	guix archive --authorize < ~/.config/guix/current/share/guix/ci.guix.info.pub

guix_daemon:
	TMPDIR=~/tmp /home/$(USER)/.config/guix/current/bin/guix-daemon --disable-chroot

guix_install:
	guix install go
	guix install vim-full
	guix install tmux
	guix install neomutt
	guix install l2md

guix_install_latest:
	for pkg in pahole llvm iproute2: do \
		guix build -f ./guix/$(pkg)-git.scm -r ~/opt/$(pkg); \
	done

nix_prepare:
	sudo mkdir /nix
	sudo chown sdf:sdf /nix
	sh <(curl -L https://nixos.org/nix/install) --no-daemon

nix_install:
	nix-env --install go
	nix-env --install vim
	nix-env --install tmux
	nix-env --install neomutt
	nix-env --install l2md

nix_install_latest:
	for pkg in pahole llvm iproute2: do \
		(cd $$pkg && nix-build --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}'); \
	done

build:
	pkg/mk pkg/golang
	pkg/mk pkg/vim
	pkg/mk pkg/llvm
	pkg/mk pkg/pahole
	pkg/mk pkg/sparse
	#pkg/mk pkg/neomutt
	#pkg/mk pkg/nvim
	#pkg/mk pkg/tmux

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))
	chmod 700 .gnupg
	chmod -R 700 ~/.secret

colors:
	base16_ocean

init:
	git submodule init && \
	git submodule sync && \
	git submodule update && \
	~/.tmux/plugins/tpm/bin/install_plugins

update:
	git submodule foreach git fetch && \
	git submodule foreach git reset --hard origin/master && \
	~/.tmux/plugins/tpm/bin/update_plugins all

alias:
	cat ~/.bash_history | cut -d' ' -f1 | cut -d'|' -f1 | sort | uniq -c | sort -n | sort -nr
