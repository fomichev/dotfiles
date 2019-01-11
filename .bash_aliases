#!/bin/sh

# ls {{{

alias ls='ls --color=auto'
alias l='ls -AF --group-directories-first';
alias a='ls -lah'

# }}}
# vim {{{

[ "$EDITOR" != "vim" ] && alias vim=$EDITOR

e() {
	if [ $# -eq 0 ]; then
		$EDITOR .
	else
		$EDITOR "$@"
	fi
}

__diff() {
	a=$(echo "$2" | sed -e 's/ /\\ /g')
	b=$(echo "$3" | sed -e 's/ /\\ /g')

	[ -z "$2" -o -z "$3" ] && { return; }
	[ -d "$2" -o -d "$3" ] && { $1 -c "DirDiff $a $b"; } || { ${1} -d "$2" "$3"; }
}

ediff() { __diff $EDITOR "$1" "$2"; }

alias s='e ~/s'
alias scratch='s'

# }}}
# mutt {{{

alias rmutt='mutt -R'

# }}}
# make {{{

alias m="make -s -j$(nproc)"
alias mm='make menuconfig'

# }}}
# gpg {{{

alias decrypt='gpg --decrypt'

gpg-restart() {
	gpgconf --reload scdaemon
	gpgconf --reload gpg-agent
}

gpg-export-ssh-agent() {
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	gpg-connect-agent updatestartuptty /bye
}

# }}}
# cd {{{

alias ..='cd .. && p'
alias ...='cd ../.. && p'
alias ....='cd ../../.. && p'
alias .....='cd ../../../.. && p'
alias ......='cd ../../../../.. && p'
alias -- -='cd - && p'

d() { builtin cd "$@" &>/dev/null && echo "$(pwd):" | colorify && l; }
complete -o filenames -o nospace -F _cd d

# }}}
# quilt {{{

alias q='quilt'

#}}}
# n {{{

_n() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $(n -l | grep "^${cur}") )
}
complete -o nospace -F _n n

# }}}
# notify {{{

notify() {
	$@
	tmux display-message "#I:#W <$?>"
}

alias ?='notify'
alias ??='tmux show-messages'

# }}}
# version control {{{

[ -e $HOME/local/bin/v ] || alias v="git"

[ -e /usr/share/bash-completion/completions/git ] && {
	. /usr/share/bash-completion/completions/git

	complete -o bashdefault -o default -o nospace -F _git v 2>/dev/null \
	    || complete -o default -o nospace -F _git v
}

# }}}
# tmux {{{

alias ta='tmux attach -d -t 0'

# }}}
# tree {{{

tree() {
	ls -R $* | grep ':$' | sed -e 's/:$//' -e 's/[^\/]*\//|  /g' -e 's/|  \([^|]\)/`--\1/g'
}

#}}}
# other {{{

alias j='jobs -l'
alias w='w -sh | sort'
alias df='df -h'
alias du='du -h'
alias info='info --vi-keys'
alias _='sudo'
sussh() { local host="$1"; shift; ssh $SSH_OPT -t "$host" sudo -i "$@"; }
alias b="$BROWSER"
alias serve="ruby -run -e httpd . -p 9090"
alias ussh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet"

# }}}
