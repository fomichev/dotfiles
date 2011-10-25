. ~/.bashrc

if [ $TERM != "screen" ]; then
	( (tmux has-session -t sdf && tmux attach-session -t sdf) || (tmux new-session -s sdf) ) && exit 0
fi
