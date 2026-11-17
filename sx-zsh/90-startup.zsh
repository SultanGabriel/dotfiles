# Set ZSH_NO_TMUX=1 to bypass tmux autostart for one shell.
if [[ -o interactive && -z "${TMUX:-}" && "${ZSH_NO_TMUX:-0}" != 1 ]] && (( $+commands[tmux] )); then
    exec tmux new-session -A -s main
fi
