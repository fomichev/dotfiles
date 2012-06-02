. ~/.bashrc

if [ $TERM != "screen" ]; then
	( (tmux has-session -t $USER && tmux attach-session -t $USER) || (tmux new-session -s $USER) ) && exit 0
fi
