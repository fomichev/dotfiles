. ~/.bashrc

if [ $TERM != "screen" ]; then
	( (tmux -q has-session && tmux attach-session -d) || (tmux new-session -s "$USER@$HOSTNAME") ) && exit 0
fi
