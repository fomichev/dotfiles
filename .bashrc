[ -z "$PS1" ] && return

# Detect OS type {{{

uname=$(uname)
on_darwin() { test $uname = 'Darwin'; }
on_linux() { test $uname = 'Linux'; }
on_cygwin() { test $uname = 'MINGW32_NT-5.1'; }
brew_prefix() { echo $(/usr/local/bin/brew --prefix $1 2>/dev/null); }
npm_prefix() { echo $(/usr/local/bin/npm prefix -g 2>/dev/null); }

# }}}
# Modify PATH {{{

path_append() { [ -e $1 ] && { export PATH=$PATH:$1; }; }
path_prepend() { [ -e $1 ] && { export PATH=$1:$PATH; }; }

on_darwin && {
	[ -d $(npm_prefix)/bin ] && {
		path_prepend $(npm_prefix)/bin
	}
}

path_prepend ~/local/vim/bin
path_prepend ~/local/llvm/bin
path_prepend ~/local/ruby/bin
path_prepend ~/local/bin
path_prepend ~/bin
path_prepend ~/.rvm/bin

path_prepend /usr/local/bin
path_prepend /usr/local/share/python

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
export CDPATH='.:~/src:~/Dropbox/src'

# enable completion
[ -r /etc/bash_completion ] && { . /etc/bash_completion; }

on_darwin && \
	[ -r $(brew_prefix)/etc/bash_completion ] && \
	{ . $(brew_prefix)/etc/bash_completion; }

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
# export TERM=xterm

# enable grep colors
export GREP_OPTIONS='--color=auto'

# add some color to man
export LESS_TERMCAP_md=$(tput setaf 4)

# disable start/stop (Ctrl-S/Ctrl-Q) functionality
on_cygwin || stty -ixon

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
