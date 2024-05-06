#!/bin/sh

# ls {{{

alias ls='ls --color=auto'
alias l='ls -AF --group-directories-first';
alias a='ls -lah'

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
# version control {{{

[ -e /usr/share/bash-completion/completions/git ] && {
	. /usr/share/bash-completion/completions/git

	__git_complete v __git_main
}

# }}}
# tmux {{{

alias ta='tmux attach -d -t 0'

# }}}
# other {{{

alias j='jobs -l'
alias info='info --vi-keys'
alias _='sudo'
alias b="$BROWSER"
alias ip="ip -color=auto"

# }}}
