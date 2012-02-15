# Detect OS type {{{

uname=`uname`
os='unknown'
[ $uname = 'Linux' ] && { os='linux'; }
[ $uname = 'Darwin' ] && { os='darwin'; }
unset uname

# }}}
# Modify PATH {{{

export PATH=/usr/local/bin:~/bin:~/local/bin:$PATH

if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:$PATH
fi

if [ -d ~/opt/vim ]; then
	export PATH=~/opt/vim/bin:$PATH
fi

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
# don't save matching lines
export HISTCONTROL=ignoreboth

# enable completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
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

# }}}
# Bookmarks {{{

function bookmark() {
	name=$1
	path=$2

	eval "alias cd-$name='cd $path && pwd'"
}

# }}}
# Include local settings {{{

if [ -e ~/local/.bashrc ]; then
	source ~/local/.bashrc
fi

# }}}
