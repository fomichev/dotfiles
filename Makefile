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

	gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
	gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
	gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"

	gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "[]"
	gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"

	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"

	gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super>j']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>k']"

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

	gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>d']"
	gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>g']"

	gsettings set org.gnome.shell.app-switcher current-workspace-only false

gnome-custom:
	# https://extensions.gnome.org/extension/5021/activate-window-by-title/

	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
		"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-browser/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-obsidian/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-code/' ]"

	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-browser/name "'Focus browser'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-browser/command \
		"'gdbus call --session --dest org.gnome.Shell --object-path /de/lucaswerkmeister/ActivateWindowByTitle --method de.lucaswerkmeister.ActivateWindowByTitle.activateBySubstring Chrome'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-browser/binding "'<Super>b'"

	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-obsidian/name "'Focus obsidian'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-obsidian/command \
		"'gdbus call --session --dest org.gnome.Shell --object-path /de/lucaswerkmeister/ActivateWindowByTitle --method de.lucaswerkmeister.ActivateWindowByTitle.activateBySubstring Obsidian'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-obsidian/binding "'<Super>o'"

	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-code/name "'Focus code'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-code/command \
		"'gdbus call --session --dest org.gnome.Shell --object-path /de/lucaswerkmeister/ActivateWindowByTitle --method de.lucaswerkmeister.ActivateWindowByTitle.activateBySubstring Workspace'"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/focus-code/binding "'<Super>o'"

gnome-dump:
	gsettings list-recursively org.gnome.mutter.keybindings
	gsettings list-recursively org.gnome.desktop.wm.keybindings
	gsettings list-recursively org.gnome.shell.keybindings

layout:
	$(call Layout,sofle,sdf,keyboard/sofle.svg)
	$(call Layout,kinesis/kint2pp,sdf,keyboard/kinesis.svg)

flash_kinesis:
	(cd $(QMK) && qmk flash -kb kinesis/redux -km fomichev)

setup_lei:
	(cd ~/src && http-proxy git clone https://public-inbox.org/public-inbox.git)
	test -f /usr/bin/apt && sudo apt install libdbd-sqlite3-perl libsearch-xapian-perl || :
	test -f /usr/bin/pacman && sudo pacman -S perl-dbd-sqlite perl-search-xapian || :
	test -f /usr/bin/dnf && sudo dnf install perl-DBD-SQLite perl-Search-Xapian || :
	~/src/public-inbox/lei.sh q \
		-I https://lore.kernel.org/all/ \
		-o ~/Mail/all --dedupe=mid \
		'(l:bpf.vger.kernel.org OR l:netdev.vger.kernel.org) AND rt:1.week.ago..'

linux:
	(cd ~/src && http-proxy git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
	(cd ~/src/linux && git remote add bpf-next https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git)
	(cd ~/src/linux && git remote add github git@github.com:fomichev/linux-private.git)
	(cd ~/src/linux && git remote add github-public git@github.com:fomichev/linux.git)
	(cd ~/src/linux && git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git)
	(cd ~/src/linux && git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git)
	(cd ~/src/linux && git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git)
	(cd ~/src/linux && http-proxy git fetch -a)
