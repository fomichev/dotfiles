#!/bin/sh

# ls {{{

on_linux && { alias ls='ls --color=auto'; }
alias a='ls -lah'

on_darwin && \
	{ alias l='ls -AF'; } || \
	{ alias l='ls -AF --group-directories-first'; }

# }}}
# vim {{{

if which mvim &>/dev/null; then
	alias gvim='mvim'
	alias vim='mvim -v'
else
	if which cvim &>/dev/null; then
		alias vim='cvim'
	else
		alias vim='vim'
	fi
fi

E() {
	if [ $# -eq 0 ]; then
		gvim --remote-silent .
	else
		gvim --remote-silent "$@"
	fi
}

e() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim "$@"
	fi
}

__diff() {
	a=$(echo "$2" | sed -e 's/ /\\ /g')
	b=$(echo "$3" | sed -e 's/ /\\ /g')

	[ -z "$2" -o -z "$3" ] && { return; }
	[ -d "$2" -o -d "$3" ] && { $1 -c "DirDiff $a $b"; } || { ${1}diff "$2" "$3"; }
}

ediff() { __diff vim "$1" "$2"; }
Ediff() { __diff gvim "$1" "$2"; }

alias s='vim ~/s'
alias scratch='s'

# }}}
# mutt {{{

alias rmutt='mutt -R'

# }}}
# make {{{

alias m='make -s'
alias mm='make menuconfig'

# }}}
# gpg {{{

alias decrypt='gpg --decrypt'

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
# surfraw {{{

alias sr='surfraw -browser=w3m'

# }}}
# quilt {{{

alias q='quilt'

#}}}
# n {{{

_n() {
    local cur IFS=$'\n'
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "$(n -l)" -- "${cur}") )
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

alias ta='tmx attach -t 0'

# }}}
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
