alias g='gvim --remote-silent'
alias ls='ls --color=auto'
alias la='ls -lah'
alias j='jobs -l'

if [ -e /usr/bin/yum ]; then
	alias install='sudo yum install'
	alias search='yum list -C'
	alias remove='sudo yum erase'
else
	alias install='sudo apt-get install'
	alias search='apt-cache search'
	alias remove='sudo apt-get remove'
fi

alias rmutt='mutt -R'

alias nake='nice -10 make'
alias jake='make -j8'

alias decrypt='gpg --decrypt'

alias w='w -sh | sort'

alias nack='ack -n'
