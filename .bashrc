 . ~/.bash_aliases

export PATH=~/bin:$PATH

if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:$PATH
fi
if [ -d ~/opt/vim ]; then
	export PATH=~/opt/vim/bin:$PATH
fi

PS1='$ '

export EDITOR=vim
export BROWSER=w3m

shopt -s cmdhist # keep the same history entries in one entry
shopt -s histappend # don't overwrite history

if [ -e ~/.bashrc_local ]; then
	source ~/.bashrc_local
fi
