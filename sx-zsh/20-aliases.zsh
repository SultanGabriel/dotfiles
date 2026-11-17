# General
alias cfg='nvim ~/.zshrc'
alias src='source ~/.zshrc'
alias genpassw="LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 16 | head -n 1"
alias ll='ls -al'
alias cdv='cd /vault/'
alias v='nvim'
alias nv='nvim'
alias sshkeys="$HOME/scripts/sshkeys.sh"
alias tmuxswitch="$HOME/scripts/tmuxswitch.sh"
alias clip='xclip -selection clipboard'


# Package and log helpers
alias make='make -j$(nproc)'
alias ninja='ninja -j$(nproc)'
alias n='ninja'
alias rmpkg='sudo pacman -Rsn'
alias cleanch='sudo pacman -Scc'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias update='sudo pacman -Syu'
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
alias jctl='journalctl -p 3 -xb'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Servers
typeset -gr COOCKEROO='root@92.38.162.85'
#typeset -gr RBigZAP='root@185.249.197.115'
#typeset -gr BigZAP='sultan@185.249.197.115'
#typeset -gr RBiscuit='root@88.99.213.238'
typeset -gr Biscuit='sultan@88.99.213.238'
typeset -gr Micutzu='sultan@192.168.178.22'

alias biscuit='ssh -o ServerAliveInterval=60 $Biscuit'
#alias zappie='ssh -o ServerAliveInterval=60 $BigZAP'
alias micutzu='ssh -o ServerAliveInterval=60 $Micutzu'
