#!/bin/sh

alias ..='cd .. && p'
alias ...='cd ../.. && p'
alias ....='cd ../../.. && p'
alias .....='cd ../../../.. && p'
alias ......='cd ../../../../.. && p'

alias ls='ls --color=auto'
alias l='ls -AF --group-directories-first';
alias a='ls -lah'
alias ta='tmux attach -d -t 0'
alias j='jobs -l'
alias info='info --vi-keys'
alias _='sudo'
alias ip="ip -color=auto"

d() { builtin cd "$@" &>/dev/null && echo "$(pwd):" | colorify && l; }
complete -o filenames -o nospace -F _cd d

gpg-export-ssh-agent() {
	if ! systemctl is-active -q pcscd.service; then
		sudo systemctl start pcscd.service
	fi

	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	gpg-connect-agent updatestartuptty /bye
}

[ -e /usr/share/bash-completion/completions/git ] && {
	. /usr/share/bash-completion/completions/git

	__git_complete v __git_main
}
