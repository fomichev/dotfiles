NAME:=vim
GIT:=https://github.com/vim/vim.git

include Makefile.lib

CONFIGURE_FLAGS+= --with-features=huge
CONFIGURE_FLAGS+= --disable-nls
CONFIGURE_FLAGS+= --disable-acl
CONFIGURE_FLAGS+= --disable-gpm
CONFIGURE_FLAGS+= --disable-sysmouse
CONFIGURE_FLAGS+= --disable-netbeans
CONFIGURE_FLAGS+= --enable-rubyinterp=yes
CONFIGURE_FLAGS+= --enable-pythoninterp=yes
CONFIGURE_FLAGS+= --with-x
CONFIGURE_FLAGS+= --with-gnome
CONFIGURE_FLAGS+= --enable-multibyte
CONFIGURE_FLAGS+= --prefix=$(PREFIX)

pre_configure:
	find $(PKG_SRC) -name configure -exec chmod +x {} \;
	find $(PKG_SRC) -name which.sh -exec chmod +x {} \;

post_install:
	cp -a $(PKG_SRC)/runtime/keymap $(PREFIX)/share/vim/vim73/

build:
	$(SUBMAKE) build_autoconf
