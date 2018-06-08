[ -z "$PS1" ] && return
[ -e ~/local/.bash_profile ] && { . ~/local/.bash_profile; }
. ~/.bashrc

export PATH="$HOME/.cargo/bin:$PATH"
