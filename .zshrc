# PATHS
export WORKSPACE=${HOME}/workspace
export CONDA=${HOME}/miniconda3/bin
export ZSH=${HOME}/.oh-my-zsh
export PATH=${HOME}/bin:${HOME}/.local/bin:${HOME}/bin:${CONDA}:${PATH}

# Antigen
source ${WORKSPACE}/antigen/antigen.zsh

# LOAD OH-MY-ZSH
antigen use oh-my-zsh

# OH-MY-ZSH CONFIGURATION
DISABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"

# Load Liquid Prompt
source ${WORKSPACE}/liquidprompt/liquidprompt
# Configure the desired variant
DOTMATRIX_VARIANT="chevron"
# Load the theme
source ${WORKSPACE}/lp-dotmatrix/dotmatrix.theme && lp_theme dotmatrix

# ANTIGEN BUNDLES
antigen bundle aws
antigen bundle command-not-found
antigen bundle copyfile
antigen bundle docker
antigen bundle extract
antigen bundle git
antigen bundle screen
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# ALIAS
source ~/.alias

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
