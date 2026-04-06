#!/bin/sh

alias ..='cd .. && p'
alias ...='cd ../.. && p'
alias ....='cd ../../.. && p'
alias .....='cd ../../../.. && p'
alias ......='cd ../../../../.. && p'

alias ls='ls --color=auto'
alias l='ls -AF --group-directories-first';
alias a='ls -lah'
alias j='jobs -l'
alias info='info --vi-keys'
alias _='sudo'
alias ip="ip -color=auto"

d() { builtin cd "$@" &>/dev/null && echo "$(pwd):" | colorify && l; }
complete -o filenames -o nospace -F _cd d

ta() {
	if [[ $# -ne 0 ]]; then
		tmux attach -d -t "$@"
	else
		tmux attach -d -t $(tmux list-sessions | head -n1 | cut -d: -f1)
	fi
}

gpg-export-ssh-agent() {
	if ! systemctl is-active -q pcscd.service; then
		sudo systemctl start pcscd.service
	fi

	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	gpg-connect-agent updatestartuptty /bye
}

http-proxy() {
	if [[ $# -ne 0 ]];  then
		eval ~/bin/http-proxy "$@"
	fi

	source ~/bin/http-proxy
}

[ -e /usr/share/bash-completion/completions/git ] && {
	. /usr/share/bash-completion/completions/git

	__git_complete v __git_main
}

alias sound=wiremix
alias wifi=impala
alias bluetooth=bluetui
