# Editor
if [[ -n "${SSH_CONNECTION:-}" ]]; then
    export EDITOR=vim
else
    export EDITOR=nvim
fi

# User binaries
export PATH="$HOME/.local/bin:$HOME/scripts/apps:$PATH"
