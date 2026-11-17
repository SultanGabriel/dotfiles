# FZF
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

# HEMTT completion
if (( $+commands[hemtt] )); then
    source <(hemtt manage completions zsh)
fi

# Conda
if [[ -x "$HOME/miniforge3/bin/conda" ]]; then
    eval "$($HOME/miniforge3/bin/conda shell.zsh hook)"
fi
