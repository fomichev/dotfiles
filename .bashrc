# Detect OS type {{{

uname=`uname`
os='unknown'
[ $uname = 'Linux' ] && { os='linux'; }
[ $uname = 'Darwin' ] && { os='darwin'; }
unset uname

# }}}
# Modify PATH {{{

export PATH=/usr/local/bin:~/bin:$PATH

if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:$PATH
fi

if [ -d ~/opt/vim ]; then
	export PATH=~/opt/vim/bin:$PATH
fi

if [ $os = 'darwin' ]; then
	if [ -d `brew --prefix ruby`/bin ]; then
		export PATH=`brew --prefix ruby`/bin:$PATH
	fi
fi

# local bin gets precedence over evertything
export PATH=~/local/bin:$PATH

# }}}
# Include aliases {{{

. ~/.bash_aliases

# }}}
# Bash settings {{{

PS1='$ '

# keep the same multi line history entries in one entry
shopt -s cmdhist
# don't overwrite history
shopt -s histappend
# don't try to complete empty line
shopt -s no_empty_cmd_completion
# don't save matching lines
export HISTCONTROL=ignoreboth
# an argument to the cd builtin command that is not a directory is assumed
# to be the name of a variable whose value is the directory to change to
shopt -s cdable_vars

dotfiles=~/dotfiles

# enable completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ $os = 'darwin' ]; then
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi
fi

# }}}
# OS dependent settings {{{

[ $os = 'linux' ] && {
	# enable ls colors
	eval `dircolors ~/.dir_colors`
}

[ $os = 'darwin' ] && {
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

if [ -e ~/local/.bashrc ]; then
	source ~/local/.bashrc
fi

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
