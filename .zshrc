# PATHS
export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/bin

# LOAD ANTIGEN — plugin manager
source $HOME/antigen/antigen.zsh

# LOAD OH-MY-ZSH
antigen use oh-my-zsh

# AUTO-UPDATES
export UPDATE_ZSH_DAYS=1

# DISABLE AUTOCORRECTION
DISABLE_CORRECTION="true"

# DATE
HIST_STAMPS="yyyy-mm-dd"

# BUNDLES
antigen bundle command-not-found
antigen bundle extract
antigen bundle git
antigen bundle git-extras
antigen bundle Tarrasch/zsh-bd
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# ALIAS
source ~/.alias

# HUB
eval "$(hub alias -s)"
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
