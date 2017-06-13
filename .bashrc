[ -z "$PS1" ] && return

umask 027

# Detect OS type {{{

uname=$(uname)
on_darwin() { test $uname = 'Darwin'; }
on_linux() { test $uname = 'Linux'; }
on_cygwin() { test $uname = 'MINGW32_NT-5.1'; }
brew_prefix() { echo $(/usr/local/bin/brew --prefix $1 2>/dev/null); }
npm_prefix() { echo $(/usr/local/bin/npm prefix -g 2>/dev/null); }

on_cygwin && return # do nothing on cygwin

# }}}
# Modify PATH {{{

path_append() { [ -e $1 ] && { export PATH=$PATH:$1; }; }
path_prepend() { [ -e $1 ] && { export PATH=$1:$PATH; }; }
try_source() { [ -r $1 ] && { . $1; }; }

on_darwin && {
	[ -d $(npm_prefix)/bin ] && {
		path_prepend $(npm_prefix)/bin
	}
}

OPT_DIR=$HOME/opt

path_prepend $OPT_DIR/bin
path_prepend $OPT_DIR/vim/bin
path_prepend $OPT_DIR/llvm/bin
path_prepend $OPT_DIR/ruby/bin
path_prepend $OPT_DIR/mutt/bin
path_prepend $OPT_DIR/tmux/bin
path_prepend ~/local/bin
path_prepend ~/bin
path_prepend ~/.rvm/bin

path_prepend /usr/local/bin
path_prepend /usr/local/share/python

# }}}
# Go {{{

export GOROOT=$OPT_DIR/go
path_prepend $GOROOT/bin

export GOPATH=$HOME/go
path_prepend $GOPATH/bin

# }}}
# Include RVM {{{

[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

# }}}
# Include Tmuxifier {{{

[ -e ~/.bundle/tmuxifier/bin/tmuxifier ] && {
	export TMUXIFIER_LAYOUT_PATH=~/.tmuxifier
	path_prepend ~/.bundle/tmuxifier/bin
	eval "$(tmuxifier init -)"
}

# }}}
# Include aliases {{{

. ~/.bash_aliases

# }}}
# Bash settings {{{

PS1='\$ '

# keep the same multi line history entries in one entry
shopt -s cmdhist
# don't overwrite history
shopt -s histappend
# don't try to complete empty line
shopt -s no_empty_cmd_completion
# don't save matching lines
export HISTCONTROL=ignoreboth
# the search path for the `cd' command
export CDPATH='.:~/src:~/Dropbox/src:~/y/src:~/go/src'

# enable completion
try_source /etc/bash_completion
try_source /etc/profile.d/bash_completion.sh

on_darwin && $(brew_prefix)/etc/profile.d/bash_completion

# }}}
# OS dependent settings {{{

on_linux && {
	# enable ls colors
	eval $(dircolors ~/.dir_colors)
}

on_darwin && {
	# enable ls colors
	export CLICOLOR=
}

# }}}
# Utilities settings {{{

export EDITOR=vim
export BROWSER=w3m

# add some color to man
export LESS_TERMCAP_md=$(tput setaf 4)

# disable start/stop (Ctrl-S/Ctrl-Q) functionality
stty -ixon

# }}}
# Include local settings {{{

[ -e ~/local/.bashrc ] && { . ~/local/.bashrc; }

# }}}
# Cowsay {{{

if [[ $- == *i* ]]; then
	[ -x /usr/bin/cowsay ] && { cowsay $(fortune); }
fi

# }}}
# Tree {{{

tree() {
	ls -R $* | grep ':$' | sed -e 's/:$//' -e 's/[^\/]*\//|  /g' -e 's/|  \([^|]\)/`--\1/g'
}

#}}}
