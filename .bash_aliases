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
	alias v='mvim --remote-silent'
else
	alias v='gvim --remote-silent'
fi

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
# package management {{{

if which yum &>/dev/null; then
	alias install='sudo yum install'
	alias search='sudo yum list -C | grep '
	alias remove='sudo yum erase'
	alias upgrade='sudo yum upgrade --skip-broken'
elif which apt-get &>/dev/null; then
	alias install='sudo apt-get install'
	alias search='apt-cache search'
	alias remove='sudo apt-get remove'
	alias upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
elif which brew &>/dev/null; then
	alias install='brew install'
	alias search='brew search'
	alias remove='brew remove'
	alias upgrade='brew update && brew upgrade'
fi

# }}}
# other {{{
alias w='w -sh | sort'
alias df='df -h'
alias info='info --vi-keys'
# }}}
