[ -z "$PS1" ] && return

umask 027

# Modify PATH {{{

path_append() { [ -e $1 ] && { export PATH=$PATH:$1; }; }
path_prepend() { [ -e $1 ] && { export PATH=$1:$PATH; }; }
try_source() { [ -r $1 ] && { . $1; }; }

path_prepend ~/opt/bin
path_prepend ~/local/bin
path_prepend ~/bin
path_prepend ~/go/bin

path_prepend /usr/local/bin
path_prepend /usr/local/share/python

# }}}
# Include aliases {{{

try_source ~/.bash_aliases

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

# }}}
# FZF {{{

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# }}}
# Utilities settings {{{

export EDITOR=nvim
export BROWSER=w3m

# add some color to man
export LESS_TERMCAP_md=$(tput setaf 4)

# base16 colors
BASE16_SHELL=$HOME/src/dotfiles/base16-shell/
[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
try_source ~/.base16_theme

# disable start/stop (Ctrl-S/Ctrl-Q) functionality
stty -ixon

# }}}
# Include local settings {{{

try_source ~/local/.bashrc

# }}}
