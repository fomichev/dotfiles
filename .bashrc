export PATH=/usr/local/bin:~/bin:~/local/bin:$PATH

 . ~/.bash_aliases

if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:$PATH
fi
if [ -d ~/opt/vim ]; then
	export PATH=~/opt/vim/bin:$PATH
fi

PS1='$ '

export EDITOR=vim
export BROWSER=w3m
# export TERM=xterm

shopt -s cmdhist # keep the same history entries in one entry
shopt -s histappend # don't overwrite history

export GREP_OPTIONS='--color=auto'

if [ -e ~/local/.bashrc ]; then
	source ~/local/.bashrc
fi

eval `dircolors ~/.dir_colors`
