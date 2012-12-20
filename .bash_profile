. ~/.bashrc

on_cygwin || [ -z "$TMUX" ] && [ ! "$TERM" = "screen" ] && tmux -V &>/dev/null && {
	tmux -q has-session && exec tmux attach-session -d
	exec tmux new-session -s "$USER@$HOSTNAME"
}
