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

alias scratch='vim ~/scratch.txt'

# }}}
# mutt {{{

alias rmutt='mutt -R'

# }}}
# make {{{

alias m='make -s V=9'

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

d() { builtin cd "$@" &>/dev/null && colorify "echo $(pwd):" && l; }
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
# other {{{

alias j='jobs -l'
alias w='w -sh | sort'
alias df='df -h'
alias du='du -h'
alias info='info --vi-keys'
alias _='sudo'
alias b="$BROWSER"

# }}}
