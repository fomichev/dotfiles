#!/bin/sh

setxkbmap -layout "us, ru" -option "grp:alt_shift_toggle"

xscreensaver -nosplash &
VBoxClient-all &
dropboxd &
xxkb &

DEFAULT_SESSION=awesome
case $1 in
  awesome|wmii|xmonad) exec $1 ;;
  *) exec $DEFAULT_SESSION ;;
esac
