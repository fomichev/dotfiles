#!/bin/sh

if [ -f ~/.Xmodmap ]; then
	xmodmap ~/.Xmodmap
fi

if [ -e /sbin/launchd ]; then
	# we're on a mac
	. /usr/X11R6/lib/X11/xinit/xinitrc
fi
