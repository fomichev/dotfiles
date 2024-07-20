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

QMK=$(HOME)/src/keyboard/qmk_firmware
KEYMAP=~/tmp/keymap-drawer/bin/keymap

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

define Layout
	(cd $(QMK) && qmk c2json -kb $1 -km $2 | $(KEYMAP) parse -q - | $(KEYMAP) draw - ) > $3
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
	mkdir -p ~/.secret
	chmod -R 700 ~/.secret

fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

colors:
	base16_precious-dark-fifteen

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

gnome:
	# https://wiki.archlinux.org/index.php/Logitech_Marble_Mouse#Gnome_3_and_Wayland
	gsettings set org.gnome.desktop.peripherals.trackball scroll-wheel-emulation-button 3

	gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>q']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>h']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>l']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
	gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
	gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"

scp:
	git ls-tree -r --name-only HEAD | tar -cz -T - | ssh $(DEVSERVER) tar xzf -

layout:
	$(call Layout,sofle,sdf,keyboard/sofle.svg)
	$(call Layout,kinesis/kint2pp,sdf,keyboard/kinesis.svg)

flash_kinesis:
	(cd $(QMK) && qmk flash -kb handwired/kinesis -km sdf)

flash_kinesis_kint:
	(cd $(QMK) && qmk flash -kb kinesis/kint2pp -km sdf)

flash_sofle:
	(cd $(QMK) && qmk flash -kb sofle -km sdf)

flash_sofle_choc:
	(cd $(QMK) && qmk flash -kb sofle_choc -km sdf)
