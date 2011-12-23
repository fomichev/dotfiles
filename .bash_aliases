alias vi='vim'

alias ls='ls --color=auto'
alias la='ls -lah'
alias j='jobs -l'

alias rmutt='mutt -R'

alias nake='nice -10 make'
alias jake='make -j8'

alias decrypt='gpg --decrypt'

alias w='w -sh | sort'

alias nack='ack -n'

alias ..='cd ..'

alias df='df -h'

if which -s mvim; then
	alias g='mvim --remote-silent'
else
	alias g='gvim --remote-silent'
fi

if which -s yum; then
	alias install='sudo yum install'
	alias search='sudo yum list -C | grep '
	alias remove='sudo yum erase'
	alias upgrade='sudo yum upgrade --skip-broken'
elif which -s apt-get; then
	alias install='sudo apt-get install'
	alias search='apt-cache search'
	alias remove='sudo apt-get remove'
	alias upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
elif which -s brew; then
	alias install='brew install'
	alias search='brew search'
	alias remove='brew remove'
	alias upgrade='brew update && brew upgrade'
fi
