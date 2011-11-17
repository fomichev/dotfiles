alias vi='vim'

if [ -e /usr/local/bin/mvim ]; then
	alias g='mvim --remote-silent'
else
	alias g='gvim --remote-silent'
fi

alias ls='ls --color=auto'
alias la='ls -lah'
alias j='jobs -l'

if [ -e /usr/bin/yum ]; then
	alias install='sudo yum install'
	alias search='sudo yum list -C | grep '
	alias remove='sudo yum erase'
	alias upgrade='sudo yum upgrade --skip-broken'
else
	alias install='sudo apt-get install'
	alias search='apt-cache search'
	alias remove='sudo apt-get remove'
	alias upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
fi

alias rmutt='mutt -R'

alias nake='nice -10 make'
alias jake='make -j8'

alias decrypt='gpg --decrypt'

alias w='w -sh | sort'

alias nack='ack -n'

alias ..='cd ..'

alias df='df -h'
