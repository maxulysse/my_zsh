# based on https://github.com/CodeMonkeyMike/ZshTheme-CodeMachine

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

if [ "$(whoami)" = "root" ]
then TIP_COLOR="%{$fg_bold[red]%}"
else TIP_COLOR="%{$FG[021]%}"
fi

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "$SSH"
  fi
}
# Outputs a symbol for the repository type
function repos_type {
  git branch >/dev/null 2>/dev/null && echo '' && return
  hg root >/dev/null 2>/dev/null && echo '${PREFIX}☿${SUFFIX}' && return
  echo ''
}
START_LINE_ONE="%{$FG[19]%}╭──"
START_LINE_TWO="%{$FG[19]%}╰─"
THE_TIP="${TIP_COLOR}≻%{$reset_color%}"
PREFIX="%{$FG[019]%}[ "
SUFFIX="%{$FG[019]%} ]"
MY_USER="%{$fg_bold[white]%}%n"
MY_HOST="%{$fg_bold[white]%}%m"
MY_PATH="%{$fg_bold[white]%}%${PWD/#$HOME/~}"
SSH="%{$fg_bold[green]%}(ssh)"

# Line one and two of the prompt
PROMPT='${START_LINE_ONE}${PREFIX}${MY_USER}@${MY_HOST}${SUFFIX} ${PREFIX}${MY_PATH}${SUFFIX} $(my_git_prompt) $(ssh_connection) $(repos_type)
${START_LINE_TWO}${THE_TIP}'

#Git Repo Info
ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[020]%}[ %{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✘"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $FG[020]]%{$reset_color%}"
