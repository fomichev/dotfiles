#!/bin/sh

# ls {{{

[ $os = "linux" ] && { alias ls='ls --color=auto'; }
alias la='ls -lah'
alias l='ls -AF'
alias j='jobs -l'

# }}}
# vim {{{

if which cvim &>/dev/null; then
	alias vim='cvim'
else
	alias vim='vim'
fi

if which mvim &>/dev/null; then
	alias gvim=mvim
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

alias m='make'

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

# }}}
# other {{{

alias w='w -sh | sort'
alias df='df -h'
alias info='info --vi-keys'

# }}}
