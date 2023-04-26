export MOZ_ENABLE_WAYLAND=1

[ -z "$PS1" ] && return
[ -e ~/local/.bash_profile ] && { . ~/local/.bash_profile; }
. ~/.bashrc
