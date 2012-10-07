#!/bin/sh

setxkbmap -layout "us, ru" -option "grp:ctrl_shift_toggle"

xscreensaver -nosplash &
VBoxClient-all &
dropboxd &
xmodmap ~/.Xmodmap &

fnmode=/sys/module/hid_apple/parameters/fnmode
[ -e $fnmode ] && {
	# use F<> keys without the need to press Fn
	sudo bash -c "echo 2 > $fnmode";
}

exec wmii
