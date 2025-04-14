# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/snap/bin/:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# extra sspacing.. blablabla
setopt PROMPT_SP

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="lambda"
# ZSH_THEME="random"
# ZSH_THEME="sultan-penguin"
# ZSH_THEME="ak-stickman"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
 zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(web-search tmux git ssh-agent tmuxinator)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# ---- [ ---- My Very Helpful Functions ---- ] ----


# ---- [ ---- My Very Cool Aliases ---- ] ----

# -- { --- Chapter 1: General Aliases --- } --
alias cfg="nvim ~/.zshrc"
alias src="source ~/.zshrc"

alias genpassw="cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1"

alias ll="ls -al"
alias cdv="cd /vault/"
alias v="nvim"
alias nv="nvim" 

alias sshkeys="~/scripts/sshkeys.sh"
alias ssh-stop='ssh-add -D && eval "$(ssh-agent -k)" && echo "🔒 SSH keys removed and agent killed."'

alias CHROME_DEV="/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe --user-data-dir='C://chrome-dev-disabled-security' --disable-web-security --disable-site-isolation-trials & disown"

alias tmuxswitch="~/scripts/tmuxswitch.sh"

# -- { --- Chapter 2: Directory Aliases --- } --

alias SULTAN='cd /mnt/c/Users/sulta/'

export RWTH='cd /mnt/s/RWTH/'
alias RWTH='cd $RWTH'
alias COOCKEROO='cd /mnt/s/Coockeroo'
export AWSI='cd /mnt/s/AWSI'
alias AWSI='cd $AWSI'

export ATM='/mnt/s/Games/ATM9Modpack'
alias ATM='cd $ATM'

export CC_SIM='/mnt/s/Programms/CraftOS-PC-Portable'
alias CC_SIM='cd $CC_SIM'


# Projects
export PROJECTS="/mnt/s/Projects"
alias P="cd $PROJECTS"

# AWSI
export POSSIBLE="/home/sultan/Downloads/nextcloud-docker-dev/workspace/server/apps-extra/awsitestapplication"
alias POSSIBLE="cd $POSSIBLE"
export UFE="/mnt/s/AWSI/CloudLab/UnifiedFrontends/"
alias UFE="cd $UFE"


# -- { --- Chapter 3: Server Aliases --- } --

export COOCKEROO='root@92.38.162.85'
export RBigZAP='root@185.249.197.115'
export BigZAP='sultan@185.249.197.115'

alias zappie="ssh -o ServerAliveInterval=60 $BigZAP"

export Micutzu='sultan@192.168.0.99'
alias micutzu="ssh -o ServerAliveInterval=60 $Micutzu"


# --- { --- Chapter 4: WSL Aliases --- } ---
# if [ -d "/mnt/c/Python312" ]; then
#     alias python="/mnt/c/Python312/python.exe"
#     alias pip="/mnt/c/Python312/Scripts/pip.exe"
# fi

# --- [ --- ZSH CONFIGURATION --- ] ---

# Open tmux on startup, requires tmux plugin
# ZSH_TMUX_AUTOSTART=true
if [[ -z "$TMUX" && -z "$TMUXINATOR_PROJECT" ]]; then
  tmuxinator start default
fi

source $ZSH/oh-my-zsh.sh

# --- [ --- ENVIRONMENT SHIT --- ] ---

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load Angular CLI autocompletion.
source <(ng completion script)

# Go
export PATH=$PATH:/usr/local/go/bin

# FZF 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PyENV
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


# --- [ --- END OF FILE --- ] ---

