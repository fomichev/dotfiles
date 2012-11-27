#!/bin/sh

# ls {{{

[ $os = "linux" ] && { alias ls='ls --color=auto'; }
alias la='ls -lah'
alias l='ls -AF'

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
		gvim --remote-silent $*
	fi
}

e() {
	if [ $# -eq 0 ]; then
		vim .
	else
		vim $*
	fi
}

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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias -- -='cd -'

c() { builtin cd $* &>/dev/null && colorify "echo $(pwd):" && l; }
complete -o filenames -o nospace -F _cd c

alias p='pwd'

# }}}
# find {{{

f() { find . -name "$*" -print; }

# }}}
# surfraw {{{

alias sr='surfraw -browser=w3m'

# }}}
# other {{{

alias j='jobs -l'
alias w='w -sh | sort'
alias df='df -h'
alias du='du -h'
alias info='info --vi-keys'

# }}}
