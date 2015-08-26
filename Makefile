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

all: install init submodules $(BIN) $(SRC) vim llvm ruby mutt tmux

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

SRC:=$(HOME)/tmp/src
BIN:=$(HOME)/tmp/bin
PREFIX:=$(HOME)/local

$(SRC):
	mkdir -p $(SRC)

$(BIN):
	mkdir -p $(BIN)

VIM_SRC:=$(SRC)/vim
VIM_DIR:=$(PREFIX)/vim

$(VIM_SRC):
	cd $(dir $(VIM_SRC)) && \
	hg clone https://code.google.com/p/vim/ && \
	(cd $(VIM_SRC) && hg pull -u)

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

LLVM_VER:=3.4
LLVM_SRC:=$(SRC)/llvm-$(LLVM_VER)
LLVM_BIN:=$(BIN)/llvm
LLVM_DIR:=$(PREFIX)/llvm

$(LLVM_SRC):
	cd $(dir $(LLVM_SRC)) && \
	curl -O http://llvm.org/releases/$(LLVM_VER)/llvm-$(LLVM_VER).src.tar.gz && \
	curl -O http://llvm.org/releases/$(LLVM_VER)/clang-$(LLVM_VER).src.tar.gz && \
	tar xf llvm-$(LLVM_VER).src.tar.gz && \
	tar xf clang-$(LLVM_VER).src.tar.gz && \
	mv clang-$(LLVM_VER) llvm-$(LLVM_VER)/tools/clang

$(LLVM_DIR)/bin/llvm: $(LLVM_SRC)
	mkdir -p $(LLVM_BIN) && cd $(LLVM_DIR) && \
	$(LLVM_SRC)/configure --with-clang \
		    --prefix=$(LLVM_DIR) && \
	make && make install

llvm: $(LLVM_DIR)/bin/llvm

RUBY_VER:=2.1.0
RUBY_SRC:=$(SRC)/ruby-$(RUBY_VER)
RUBY_BIN:=$(BIN)/ruby
RUBY_DIR:=$(PREFIX)/ruby

$(RUBY_SRC):
	cd $(dir $(RUBY_SRC)) && \
	curl -O http://ftp.ruby-lang.org/pub/ruby/ruby-$(RUBY_VER).tar.gz && \
	tar xf ruby-$(RUBY_VER).tar.gz

$(RUBY_DIR)/bin/ruby: $(RUBY_SRC)
	mkdir -p $(RUBY_BIN) && cd $(RUBY_DIR) && \
	$(RUBY_SRC)/configure --prefix=$(RUBY_DIR) && \
	make && make install

ruby: $(RUBY_DIR)/bin/ruby

MUTT_VER:=1.5.22
MUTT_SRC:=$(SRC)/mutt-$(MUTT_VER)
MUTT_BIN:=$(BIN)/mutt
MUTT_DIR:=$(PREFIX)/mutt

$(MUTT_SRC):
	cd $(dir $(MUTT_SRC)) && \
	curl -O ftp://ftp.mutt.org/mutt/devel/mutt-$(MUTT_VER).tar.gz && \
	tar xf mutt-$(MUTT_VER).tar.gz && \
	(cd $(MUTT_SRC) && \
		curl -O https://raw2.github.com/nedos/mutt-sidebar-patch/master/mutt-sidebar.patch && \
		patch -p1 < mutt-sidebar.patch)

$(MUTT_DIR)/bin/mutt: $(MUTT_SRC)
	mkdir -p $(MUTT_BIN) && cd $(MUTT_DIR) && \
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

TMUX_VER:=2.0
TMUX_SRC:=$(SRC)/tmux-$(TMUX_VER)
TMUX_BIN:=$(BIN)/tmux
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
