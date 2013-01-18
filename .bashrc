[ -z "$PS1" ] && return

# Detect OS type {{{

uname=$(uname)
on_darwin() { test $uname = 'Darwin'; }
on_linux() { test $uname = 'Linux'; }
brew_prefix() { echo $(/usr/local/bin/brew --prefix $1 2>/dev/null); }
npm_prefix() { echo $(/usr/local/bin/npm prefix -g 2>/dev/null); }

# }}}
# Modify PATH {{{

path_append() { [ -e $1 ] && { export PATH=$PATH:$1; }; }
path_prepend() { [ -e $1 ] && { export PATH=$1:$PATH; }; }

export PATH=
path_prepend /bin
path_prepend /usr/bin
path_prepend /usr/local/bin
path_prepend /sbin
path_prepend /usr/sbin

on_darwin && {
	path_prepend /opt/X11/bin
	path_prepend /usr/texbin
}

path_prepend /opt/vim/bin
path_prepend ~/local/vim/bin

on_darwin && {
	[ -d $(brew_prefix)/bin ] && {
		path_prepend $(brew_prefix)/bin
		path_prepend $(brew_prefix ruby)/bin
	}

	[ -d $(npm_prefix)/bin ] && {
		path_prepend $(npm_prefix)/bin
	}
}

path_prepend ~/local/bin
path_prepend ~/bin

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
if [ -r /etc/bash_completion ]; then
	. /etc/bash_completion
fi

on_darwin && {
	if [ -r $(brew_prefix)/etc/bash_completion ]; then
		. $(brew_prefix)/etc/bash_completion
	fi
}

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
