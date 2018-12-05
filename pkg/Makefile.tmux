NAME:=tmux
GIT:=https://github.com/tmux/tmux.git

include Makefile.lib

build:
	$(SUBMAKE) build_autoconf
