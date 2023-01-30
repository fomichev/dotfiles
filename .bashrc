[ -z "$PS1" ] && return

umask 027

# Modify PATH {{{

path_append() { [ -e $1 ] && { export PATH=$PATH:$1; }; }
path_prepend() { [ -e $1 ] && { export PATH=$1:$PATH; }; }
try_source() { [ -r $1 ] && { . $1; }; }

path_prepend ~/opt/sysroot/usr/sbin
path_prepend ~/opt/sysroot/sbin
path_prepend ~/opt/sysroot/bin
path_prepend ~/opt/sysroot/go/bin
path_prepend ~/local/bin
path_prepend ~/.local/bin
path_prepend ~/bin
path_prepend ~/go/bin

path_prepend /usr/local/bin
path_prepend /usr/local/share/python

export LD_LIBRARY_PATH=/usr/local/google/home/sdf/opt/sysroot/lib

# }}}
# Include aliases {{{

export EDITOR=vim

if [[ -e /usr/bin/nvim ]]; then
	export EDITOR=nvim
fi

export SYSTEMD_EDITOR=$EDITOR
export BROWSER=w3m

try_source ~/.bash_aliases

# }}}
# Bash settings {{{

PS1='\$ '

# keep the same multi line history entries in one entry
shopt -s cmdhist
# multi-line commands are saved with embedded new lines
shopt -s lithist
# don't overwrite history
shopt -s histappend
# don't try to complete empty line
shopt -s no_empty_cmd_completion
# keep up to a million history entries (up from default 64k)
export HISTFILESIZE=1000000
export HISTSIZE=$HISTFILESIZE

# ignore duplicates
_ignore+="&:"
# ignore everything starting with a space
_ignore+="[ ]*:"
# ignore cd shortcuts
_ignore+="..:...:....:....."
# ignore specific commands
_ignore+="a:"
_ignore+="e:"
_ignore+="d:"
_ignore+="df:"
_ignore+="du:"
_ignore+="j:"
_ignore+="l:"
_ignore+="p:"
_ignore+="s:"
export HISTIGNORE="$_ignore"

# don't waste space in history file with timestamps
unset HISTTIMEFORMAT

history_defrag() {
	mv ~/.bash_history ~/.bash_history.bak
	cat ~/.bash_history.bak | egrep -v '^#' | sort | uniq > ~/.bash_history
}

# enable completion
try_source /etc/bash_completion
try_source /etc/profile.d/bash_completion.sh

# }}}
# FZF {{{

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# }}}
# Utilities settings {{{

# add some color to man
export LESS_TERMCAP_md=$(tput setaf 4)

if [ -z "$NO_BASE16" ]; then
	# base16 colors
	BASE16_SHELL=$HOME/src/dotfiles/base16-shell/
	[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
	try_source ~/.base16_theme
fi

# disable start/stop (Ctrl-S/Ctrl-Q) functionality
stty -ixon

# }}}
# Include local settings {{{

try_source ~/local/.bashrc

# }}}
