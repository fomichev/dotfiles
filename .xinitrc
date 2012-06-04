#!/bin/sh

setxkbmap -layout "us, ru" -option "grp:rwin_toggle"

xscreensaver -nosplash &
VBoxClient-all &
dropboxd &
xmodmap ~/.Xmodmap &

fnmode=/sys/module/hid_apple/parameters/fnmode
[ -e $fnmode ] && {
	# use F<> keys without need to press Fn
	sudo bash -c "echo 2 > $fnmode";

	# swap Super and Alt
	xmodmap -e "remove mod1 = Alt_L"
	xmodmap -e "remove mod4 = Super_L"
	xmodmap -e "keycode 133 = Alt_L"
	xmodmap -e "keycode 64 = Super_L"
	xmodmap -e "add mod1 = Alt_L"
	xmodmap -e "add mod4 = Super_L"
}

exec wmii
