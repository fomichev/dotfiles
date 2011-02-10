 . ~/.bash_aliases

export PATH=~/bin:$PATH

# use extra Vim
if [ -d /opt/vim ]; then
	export PATH=/opt/vim/bin:$PATH
fi
if [ -d ~/opt/vim ]; then
	export PATH=~/opt/vim/bin:$PATH
fi

# use extra bash settings
if [ -e ~/.work_bashrc ]; then
	source ~/.work_bashrc
fi

PS1='$ '

export EDITOR=vim

shopt -s cmdhist # keep the same history entries in one entry
shopt -s histappend # don't overwrite history
