source /usr/share/cachyos-fish-config/cachyos-config.fish


# ------------------------------------------------------------
# EDITOR
# ------------------------------------------------------------

if set -q SSH_CONNECTION
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end


# ------------------------------------------------------------
# GENERAL ALIASES
# ------------------------------------------------------------

alias cfg='nvim ~/.config/fish/config.fish'
alias src='source ~/.config/fish/config.fish'

alias genpassw="cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1"

alias ll='ls -al'
alias cdv='cd /vault/'
alias v='nvim'
alias nv='nvim'

alias sshkeys='~/scripts/sshkeys.sh'
alias tmuxswitch='~/scripts/tmuxswitch.sh'

alias clip='xclip -selection clipboard'

# ------------------------------------------------------------
# SERVERS
# ------------------------------------------------------------

set -gx COOCKEROO 'root@92.38.162.85'
set -gx RBigZAP 'root@185.249.197.115'
set -gx BigZAP 'sultan@185.249.197.115'
set -gx RBiscuit 'root@88.99.213.238'
set -gx Biscuit 'sultan@88.99.213.238'
set -gx Micutzu 'sultan@192.168.178.22'

alias biscuit='ssh -o ServerAliveInterval=60 $Biscuit'
alias zappie='ssh -o ServerAliveInterval=60 $BigZAP'
alias micutzu='ssh -o ServerAliveInterval=60 $Micutzu'

# ------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------

function prettylog
    git log \
        --graph \
        --all \
        --decorate \
        --date=short \
        --pretty=format:'%C(auto)%h%C(reset) %C(dim white)%ad%C(reset) %C(auto)%d%C(reset) %s %C(dim white)- %an%C(reset)'
end


# ------------------------------------------------------------
# Vim-like navigation with Alt + H/J/K/L.
# Alt+H - Cursor left
# Alt+L - Cursor right
# Alt+K - prev history entry
# Alt+J - next history entry
# ------------------------------------------------------------

bind alt-shift-h backward-char
bind alt-shift-l forward-char
bind alt-shift-k up-or-search
bind alt-shift-j down-or-search

# ------------------------------------------------------------
# Dev Environments
# ------------------------------------------------------------

function esp_activate
    source ~/git/esp-idf/export.fish
end

#function sdkman_activate
#source ~/.sdkman/bin/sdkman-init.sh
#end

# ------------------------------------------------------------
# FZF
# ------------------------------------------------------------

if type -q fzf
    fzf --fish | source
end

# ------------------------------------------------------------
# SSH AGENT
# ------------------------------------------------------------

set -l ssh_agent_ok 0

# First use an agent that this shell already inherited.
if set -q SSH_AUTH_SOCK
    ssh-add -l >/dev/null 2>&1

    # 0 = agent works and has keys.
    # 1 = agent works but has no keys.
    # 2 = agent cannot be reached.
    if test $status -ne 2
        set ssh_agent_ok 1
    end
end

# No inherited agent. Try our persistent socket.
if test $ssh_agent_ok -eq 0
    set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock

    ssh-add -l >/dev/null 2>&1

    if test $status -ne 2
        set ssh_agent_ok 1
    end
end

# Still no agent. Start one.
if test $ssh_agent_ok -eq 0
    rm -f $HOME/.ssh/agent.sock

    eval (ssh-agent -c -a $HOME/.ssh/agent.sock) >/dev/null
end


# ------------------------------------------------------------
# SSH HELPERS
# ------------------------------------------------------------

function ssh-stop
    ssh-add -D

    if set -q SSH_AGENT_PID
        ssh-agent -k >/dev/null
    end

    set -e SSH_AUTH_SOCK
    set -e SSH_AGENT_PID

    echo "SSH agent stopped."
end


# ------------------------------------------------------------
# SX PICK DIR THINGY
# ------------------------------------------------------------
function c
    set dir (sx-dir-pick)

    if test $status -ne 0
        return
    end

    if test -n "$dir"
        cd "$dir"
    end
end

# BIND ALT+C 
bind \eq 'c'

# ------------------------------------------------------------
# INTERACTIVE STARTUP
# ------------------------------------------------------------

if status is-interactive
    if not set -q TMUX
        if type -q tmux
            exec tmux new-session -A -s main
        end
    end
end

# Added by HEMTT installer
source (hemtt manage completions fish | psub)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/sultan/miniforge3/bin/conda
    eval /home/sultan/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/sultan/miniforge3/etc/fish/conf.d/conda.fish"
        . "/home/sultan/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/sultan/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<

