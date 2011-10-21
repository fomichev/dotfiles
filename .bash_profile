. ~/.bashrc

if [ -z "$TMUX" ]; then
	if tmux has-session; then
		tmux attach
	else
		tmux new bash
	fi
fi
