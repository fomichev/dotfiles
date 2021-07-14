[ -z "$PS1" ] && return
[ -e ~/local/.bash_profile ] && { . ~/local/.bash_profile; }
[ -e ~/.nix-profile/etc/profile.d/nix.sh ] && { . ~/.nix-profile/etc/profile.d/nix.sh; }
. ~/.bashrc
