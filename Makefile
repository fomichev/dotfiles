RUBY_VER:=2.3.1
MUTT_VER:=1.6.1
TMUX_VER:=2.2
GOLANG_VER:=1.6.2

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

all: install init submodules $(BUILD) $(SRC) vim ruby mutt tmux golang

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))

init:
	git submodule init && \
	git submodule sync && \
	git submodule update

submodules:
	git submodule foreach git fetch && \
	git submodule foreach git reset --hard origin/master

alias:
	cat ~/.bash_history | cut -d' ' -f1 | cut -d'|' -f1 | sort | uniq -c | sort -n | sort -nr

SRC:=$(HOME)/opt/tmp/src
BUILD:=$(HOME)/opt/tmp/bld
PREFIX:=$(HOME)/opt

$(SRC):
	mkdir -p $(SRC)

$(BUILD):
	mkdir -p $(BUILD)

VIM_SRC:=$(SRC)/vim
VIM_DIR:=$(PREFIX)/vim

$(VIM_SRC):
	cd $(dir $(VIM_SRC)) && \
	git clone https://github.com/vim/vim.git

$(VIM_DIR)/bin/vim: $(VIM_SRC)
	cd $(VIM_SRC) && \
	find -name configure -exec chmod +x {} \; && \
	find -name which.sh -exec chmod +x {} \; && \
	./configure --with-features=huge \
		    --disable-nls \
		    --disable-acl \
		    --disable-gpm \
		    --disable-sysmouse \
		    --disable-netbeans \
		    --enable-rubyinterp=yes \
		    --enable-pythoninterp=yes \
		    --with-x \
		    --with-gnome \
		    --enable-multibyte \
		    --prefix=$(VIM_DIR) && \
	make && make install && \
	cp -a runtime/keymap $(VIM_DIR)/share/vim/vim73/

vim: $(VIM_DIR)/bin/vim

vim_plugins:
	vim +PluginInstall +qall

RUBY_SRC:=$(SRC)/ruby-$(RUBY_VER)
RUBY_BIN:=$(BUILD)/ruby
RUBY_DIR:=$(PREFIX)/ruby

$(RUBY_SRC):
	cd $(dir $(RUBY_SRC)) && \
	curl -LO http://ftp.ruby-lang.org/pub/ruby/ruby-$(RUBY_VER).tar.gz && \
	tar xf ruby-$(RUBY_VER).tar.gz

$(RUBY_DIR)/bin/ruby: $(RUBY_SRC)
	mkdir -p $(RUBY_BIN) $(RUBY_DIR) && cd $(RUBY_BIN) && \
	$(RUBY_SRC)/configure --prefix=$(RUBY_DIR) && \
	make && make install

ruby: $(RUBY_DIR)/bin/ruby

MUTT_SRC:=$(SRC)/mutt-$(MUTT_VER)
MUTT_BIN:=$(BUILD)/mutt
MUTT_DIR:=$(PREFIX)/mutt

$(MUTT_SRC):
	cd $(dir $(MUTT_SRC)) && \
	curl -LO ftp://ftp.mutt.org/mutt/devel/mutt-$(MUTT_VER).tar.gz && \
	tar xf mutt-$(MUTT_VER).tar.gz && \
	(cd $(MUTT_SRC) && \
		curl -LO https://raw2.github.com/nedos/mutt-sidebar-patch/master/mutt-sidebar.patch && \
		patch -p1 < mutt-sidebar.patch)

$(MUTT_DIR)/bin/mutt: $(MUTT_SRC)
	mkdir -p $(MUTT_BIN) && cd $(MUTT_BIN) && \
	$(MUTT_SRC)/configure --prefix=$(MUTT_DIR) \
		    --enable-hcache \
		    --disable-gpgme \
		    --enable-imap \
		    --enable-smtp \
		    --enable-pop \
		    --with-curses \
		    --with-gnutls \
		    --with-gss \
		    --with-idn \
		    --with-mixmaster \
		    --with-sasl \
		    --with-regex \
		    --with-ssl && \
	make && fakeroot make install

mutt: $(MUTT_DIR)/bin/mutt

TMUX_SRC:=$(SRC)/tmux-$(TMUX_VER)
TMUX_BIN:=$(BUILD)/tmux
TMUX_DIR:=$(PREFIX)/tmux

$(TMUX_SRC):
	cd $(dir $(TMUX_SRC)) && \
	curl -LO https://github.com/tmux/tmux/releases/download/$(TMUX_VER)/tmux-$(TMUX_VER).tar.gz && \
	tar xf tmux-$(TMUX_VER).tar.gz

$(TMUX_DIR)/bin/tmux: $(TMUX_SRC)
	mkdir -p $(TMUX_BIN) && cd $(TMUX_BIN) && \
	$(TMUX_SRC)/configure --prefix=$(TMUX_DIR) && \
	make && make install

tmux: $(TMUX_DIR)/bin/tmux

GOLANG_DIR:=$(PREFIX)/go

$(GOLANG_DIR)/bin/go:
	cd $(dir $(GOLANG_DIR)) && \
	curl -LO https://storage.googleapis.com/golang/go${GOLANG_VER}.linux-amd64.tar.gz && \
	tar xf go$(GOLANG_VER).linux-amd64.tar.gz

golang: $(GOLANG_DIR)/bin/go
