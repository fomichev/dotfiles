files := $(shell find $(CURDIR) \
	-mindepth 1 -maxdepth 1 \
	-not -name Makefile \
	-not -name README \
	-not -name '.git*' \
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

all: install init submodules

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

VIM_SRC:=$(HOME)/src/vim
VIM_DIR:=$(HOME)/local/vim

$(VIM_SRC):
	cd ~/src && \
	hg clone https://code.google.com/p/vim/

vim: $(VIM_SRC)
	cd $(VIM_SRC) && \
	find -name configure -exec chmod +x {} \; && \
	find -name which.sh -exec chmod +x {} \; && \
	./configure --with-features=huge \
		    --disable-nls \
		    --disable-acl \
		    --disable-gpm \
		    --disable-sysmouse \
		    --enable-rubyinterp \
		    --enable-pythoninterp \
		    --enable-perlinterp \
		    --with-x \
		    --with-gnome \
		    --enable-multibyte \
		    --enable-cscope \
		    --prefix=$(VIM_DIR) && \
	make && make install && \
	cp -a runtime/keymap $(VIM_DIR)/share/vim/vim73/

LLVM_SRC:=$(HOME)/src/llvm
LLVM_DIR:=$(HOME)/local/llvm

$(LLVM_SRC):
	cd ~/src && \
	curl -O http://llvm.org/releases/3.2/llvm-3.2.src.tar.gz && \
	curl -O http://llvm.org/releases/3.2/clang-3.2.src.tar.gz && \
	tar xf llvm-3.2.src.tar.gz && \
	tar xf clang-3.2.src.tar.gz && \
	mv llvm-3.2.src llvm && \
	mv clang-3.2.src llvm/tools/clang

llvm: $(LLVM_SRC)
	cd $(LLVM_SRC) && \
	./configure --with-clang \
		    --prefix=$(LLVM_DIR) && \
	make && make install

RUBY_SRC:=$(HOME)/src/ruby
RUBY_DIR:=$(HOME)/local/ruby

$(RUBY_SRC):
	cd ~/src && \
	curl -O http://ftp.ruby-lang.org/pub/ruby/ruby-1.9-stable.tar.gz && \
	tar xf ruby-1.9-stable.tar.gz && \
	mv ruby-1.9.?-p??? ruby

ruby: $(RUBY_SRC)
	cd $(RUBY_SRC) && \
	make && make install
