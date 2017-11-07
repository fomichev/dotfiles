RUBY_VER:=2.4.1
MUTT_VER:=1.6.1
TMUX_VER:=2.5
GOLANG_VER:=1.9

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

all: install init submodules $(BUILD) $(SRC)

build: vim ruby mutt tmux golang

install:
	@$(foreach file,$(files),$(call InstallFile,$(file),$(HOME)/$(notdir $(file))))

colors:
	./base16-gnome-terminal/color-scripts/base16-ocean.sh

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

$(VIM_SRC):
	cd $(dir $(VIM_SRC)) && \
	git clone https://github.com/vim/vim.git

$(PREFIX)/bin/vim: $(VIM_SRC)
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
		    --prefix=$(PREFIX) && \
	make && make install && \
	cp -a runtime/keymap $(PREFIX)/share/vim/vim73/

vim: $(PREFIX)/bin/vim

vim_plugins:
	vim +PluginInstall +qall

RUBY_SRC:=$(SRC)/ruby-$(RUBY_VER)
RUBY_BIN:=$(BUILD)/ruby

$(RUBY_SRC):
	cd $(dir $(RUBY_SRC)) && \
	curl -LO http://ftp.ruby-lang.org/pub/ruby/ruby-$(RUBY_VER).tar.gz && \
	tar xf ruby-$(RUBY_VER).tar.gz

$(PREFIX)/bin/ruby: $(RUBY_SRC)
	mkdir -p $(RUBY_BIN) $(PREFIX) && cd $(RUBY_BIN) && \
	$(RUBY_SRC)/configure --prefix=$(PREFIX) && \
	make && make install

ruby: $(PREFIX)/bin/ruby

MUTT_SRC:=$(SRC)/mutt-$(MUTT_VER)
MUTT_BIN:=$(BUILD)/mutt

$(MUTT_SRC):
	cd $(dir $(MUTT_SRC)) && \
	curl -LO ftp://ftp.mutt.org/mutt/devel/mutt-$(MUTT_VER).tar.gz && \
	tar xf mutt-$(MUTT_VER).tar.gz && \
	(cd $(MUTT_SRC) && \
		curl -LO https://github.com/nedos/mutt-sidebar-patch/raw/master/mutt-sidebar.patch && \
		patch -p1 < mutt-sidebar.patch)

$(PREFIX)/bin/mutt: $(MUTT_SRC)
	mkdir -p $(MUTT_BIN) && cd $(MUTT_BIN) && \
	$(MUTT_SRC)/configure --prefix=$(PREFIX) \
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

mutt: $(PREFIX)/bin/mutt

TMUX_SRC:=$(SRC)/tmux-$(TMUX_VER)
TMUX_BIN:=$(BUILD)/tmux

$(TMUX_SRC):
	cd $(dir $(TMUX_SRC)) && \
	curl -LO https://github.com/tmux/tmux/releases/download/$(TMUX_VER)/tmux-$(TMUX_VER).tar.gz && \
	tar xf tmux-$(TMUX_VER).tar.gz

$(PREFIX)/bin/tmux: $(TMUX_SRC)
	mkdir -p $(TMUX_BIN) && cd $(TMUX_BIN) && \
	$(TMUX_SRC)/configure --prefix=$(PREFIX) && \
	make && make install

tmux: $(PREFIX)/bin/tmux

$(PREFIX)/bin/go:
	cd $(dir $(PREFIX)) && \
	curl -LO https://storage.googleapis.com/golang/go${GOLANG_VER}.linux-amd64.tar.gz && \
	tar xf go$(GOLANG_VER).linux-amd64.tar.gz

golang: $(PREFIX)/bin/go

CMAKE_VER:=3.9.0-rc2
CMAKE_SRC:=$(SRC)/cmake-$(CMAKE_VER)
CMAKE_BIN:=$(BUILD)/cmake

$(CMAKE_SRC):
	cd $(dir $(CMAKE_SRC)) && \
	curl -LO https://cmake.org/files/v3.9/cmake-$(CMAKE_VER).tar.gz && \
	tar xf cmake-$(CMAKE_VER).tar.gz

$(PREFIX)/bin/cmake: $(CMAKE_SRC)
	mkdir -p $(CMAKE_BIN) && cd $(CMAKE_BIN) && \
	$(CMAKE_SRC)/configure --prefix=$(PREFIX) && \
	make && make install

cmake: $(PREFIX)/bin/cmake

LLVM_VER:=4.0.0
LLVM_SRC:=$(SRC)/llvm-$(LLVM_VER).src
LLVM_BIN:=$(BUILD)/llvm

$(LLVM_SRC):
	cd $(dir $(LLVM_SRC)) && \
	curl -LO http://releases.llvm.org/$(LLVM_VER)/llvm-$(LLVM_VER).src.tar.xz && \
	curl -LO http://releases.llvm.org/$(LLVM_VER)/cfe-$(LLVM_VER).src.tar.xz && \
	tar xf llvm-$(LLVM_VER).src.tar.xz && \
	tar xf cfe-$(LLVM_VER).src.tar.xz && \
	mv cfe-$(LLVM_VER).src $(LLVM_SRC)/tools/clang

$(PREFIX)/bin/llvm: $(LLVM_SRC)
	mkdir -p $(LLVM_BIN) && cd $(LLVM_BIN) && \
	cmake $(LLVM_SRC) && \
	cmake --build . && \
	cmake -DCMAKE_INSTALL_PREFIX=$(PREFIX) -P cmake_install.cmake

llvm: $(PREFIX)/bin/llvm
