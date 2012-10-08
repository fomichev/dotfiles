. ~/.bashrc

[ -z "$TMUX" ] && [ ! "$TERM" = "screen" ] && {
	tmux -q has-session && exec tmux attach-session -d
	exec tmux new-session -s "$USER@$HOSTNAME"
}
