 . ~/.bash_aliases

export PATH=~/bin:$PATH

if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:~/bin:$PATH
fi

PS1='$ '

export EDITOR=vim

shopt -s cmdhist # keep the same history entries in one entry
shopt -s histappend # don't overwrite history
