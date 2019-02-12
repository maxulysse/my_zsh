# PATHS
export ZSH=$HOME/.oh-my-zsh
export GOROOT=/usr/local/go
export CONDA=$HOME/miniconda3/bin
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/bin:$GOROOT/bin:/snap/bin:$CONDA:$HOME/.rvm/bin:$PATH
export RUBY_VERSION=ruby-2.5.0
source $HOME/.rvm/scripts/rvm

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
antigen bundle aws
antigen bundle command-not-found
antigen bundle copyfile
antigen bundle docker
antigen bundle extract
antigen bundle gem
antigen bundle git
antigen bundle screen
antigen bundle Tarrasch/zsh-bd
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# ALIAS
source ~/.alias

# HUB
eval "$(hub alias -s)"
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

# Connect to Bianca
function bianca() {
    ssh -A ${USER}-"$@"@bianca.uppmax.uu.se
}

# added by Miniconda3 4.5.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/maxime/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/maxime/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/maxime/miniconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/maxime/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
