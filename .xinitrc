#!/bin/sh

VBoxClient-all &

echo "called with $1" > /home/fomichev/aaaaaa

DEFAULT_SESSION=awesome
case $1 in
  awesome|wmii|xmonad) exec $1 ;;
  *) exec $DEFAULT_SESSION ;;
esac
