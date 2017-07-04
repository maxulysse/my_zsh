# PATHS
export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/bin

# LOAD ANTIGEN — plugin manager
source $HOME/antigen/antigen.zsh

# LOAD OH-MY-ZSH
antigen use oh-my-zsh

# OH-MY-ZSH CONFIGURATION
DISABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"

# THEME
antigen theme MaxUlysse/myzsh

# ANTIGEN BUNDLES
antigen bundle command-not-found
antigen bundle extract
antigen bundle git
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
