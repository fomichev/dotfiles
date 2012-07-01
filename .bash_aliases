#!/bin/sh

# ls {{{

[ $os = "linux" ] && { alias ls='ls --color=auto'; }
alias la='ls -lah'
alias l='ls -AF'
alias j='jobs -l'

# }}}
# vim {{{

if which cvim &>/dev/null; then
	alias vi='cvim'
else
	alias vi='vim'
fi

if which mvim &>/dev/null; then
	alias gvim=mvim
fi

function E() {
	if [ $# -eq 0 ]; then
		gvim .
	else
		gvim $*
	fi
}

function e() {
	if [ $# -eq 0 ]; then
		vi .
	else
		vi $*
	fi
}

# }}}
# mutt {{{

alias rmutt='mutt -R'

# }}}
# make {{{

alias nake='nice -10 make'
alias jake='make -j8'

# }}}
# gpg {{{

alias decrypt='gpg --decrypt'

# }}}
# cd {{{

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# }}}
# other {{{

alias w='w -sh | sort'
alias df='df -h'
alias info='info --vi-keys'

# }}}
