# based on https://github.com/CodeMonkeyMike/ZshTheme-CodeMachine
# and https://github.com/arialdomartini/oh-my-git

: ${omg_is_a_git_repo_symbol:=''}
: ${omg_has_untracked_files_symbol:=''}        #                ?    
: ${omg_has_adds_symbol:=''}
: ${omg_has_deletions_symbol:=''}
: ${omg_has_cached_deletions_symbol:=''}
: ${omg_has_modifications_symbol:=''}
: ${omg_has_cached_modifications_symbol:=''}
: ${omg_ready_to_commit_symbol:=''}            #   →
: ${omg_is_on_a_tag_symbol:=''}                #   
: ${omg_needs_to_merge_symbol:='ᄉ'}
: ${omg_detached_symbol:=''}
: ${omg_can_fast_forward_symbol:=''}
: ${omg_has_diverged_symbol:=''}               #   
: ${omg_not_tracked_branch_symbol:=''}
: ${omg_rebase_tracking_branch_symbol:=''}     #   
: ${omg_merge_tracking_branch_symbol:=''}      #  
: ${omg_should_push_symbol:=''}                #    
: ${omg_has_stashes_symbol:=''}
: ${omg_has_action_in_progress_symbol:=''}     #                  

autoload -U colors && colors

if [ "$(whoami)" = "root" ]
  then TIP_COLOR="%{$fg_bold[red]%}"
  else TIP_COLOR="%{$fg_bold[blue]%}"
fi

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "$SSH"
  fi
}
START_LINE_ONE="%{$fg_bold[blue]%}╭──"
START_LINE_TWO="%{$fg_bold[blue]%}╰─"
THE_TIP="${TIP_COLOR}≻%{$reset_color%}"
PREFIX="%{$fg_bold[blue]%}[ "
SUFFIX="%{$fg_bold[blue]%} ]"
MY_USER="%{$fg_bold[white]%}%n"
MY_HOST="%{$fg_bold[white]%}%m"
MY_PATH="%{$fg_bold[white]%}%${PWD/#$HOME/~}"
SSH="%{$fg_bold[green]%}(ssh)"

# Line one and two of the prompt
PROMPT='${START_LINE_ONE}${PREFIX}${MY_USER}@${MY_HOST}${SUFFIX} ${PREFIX}${MY_PATH}${SUFFIX} $(git_prompt) $(ssh_connection)
${START_LINE_TWO}${THE_TIP}'

function get_current_action () {
  local info="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$info" ]; then
    local action
    if [ -f "$info/rebase-merge/interactive" ]
    then
      action=${is_rebasing_interactively:-"rebase -i"}
    elif [ -d "$info/rebase-merge" ]
    then
      action=${is_rebasing_merge:-"rebase -m"}
    else
      if [ -d "$info/rebase-apply" ]
      then
        if [ -f "$info/rebase-apply/rebasing" ]
        then
          action=${is_rebasing:-"rebase"}
        elif [ -f "$info/rebase-apply/applying" ]
        then
          action=${is_applying_mailbox_patches:-"am"}
        else
          action=${is_rebasing_mailbox_patches:-"am/rebase"}
        fi
      elif [ -f "$info/MERGE_HEAD" ]
      then
        action=${is_merging:-"merge"}
      elif [ -f "$info/CHERRY_PICK_HEAD" ]
      then
        action=${is_cherry_picking:-"cherry-pick"}
      elif [ -f "$info/BISECT_LOG" ]
      then
        action=${is_bisecting:-"bisect"}
      fi
    fi
    if [[ -n $action ]]; then printf "%s" "${1-}$action${2-}"; fi
  fi
}

function git_prompt {
  local enabled=`git config --local --get oh-my-git.enabled`
  local prompt=""
  if [[ ${enabled} == false ]]; then
    echo "${prompt}"
    exit;
  fi

  local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
  if [[ -n $current_commit_hash ]]; then local is_a_git_repo=true; fi

  if [[ $is_a_git_repo == true ]]; then
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ $current_branch == 'HEAD' ]]; then local detached=true; fi

    local number_of_logs="$(git log --pretty=oneline -n1 2> /dev/null | wc -l)"
    if [[ $number_of_logs -eq 0 ]]; then
      local just_init=true
    else
      local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
      if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then local has_upstream=true; fi

      local git_status="$(git status --porcelain 2> /dev/null)"
      local action="$(get_current_action)"

      if [[ $git_status =~ ($'\n'|^).M ]]; then local has_modifications=true; fi
      if [[ $git_status =~ ($'\n'|^)M ]]; then local has_modifications_cached=true; fi
      if [[ $git_status =~ ($'\n'|^)A ]]; then local has_adds=true; fi
      if [[ $git_status =~ ($'\n'|^).D ]]; then local has_deletions=true; fi
      if [[ $git_status =~ ($'\n'|^)D ]]; then local has_deletions_cached=true; fi
      if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then local ready_to_commit=true; fi

      local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
      if [[ $number_of_untracked_files -gt 0 ]]; then local has_untracked_files=true; fi

      local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
      if [[ -n $tag_at_current_commit ]]; then local is_on_a_tag=true; fi

      if [[ $has_upstream == true ]]; then
        local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
        local commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
        local commits_behind=$(\grep -c "^>" <<< "$commits_diff")
      fi

      if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then local has_diverged=true; fi
      if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then local should_push=true; fi

      local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)

      local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
      if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; fi
    fi
  fi

  echo "$(custom_git_prompt ${enabled:-true} ${current_commit_hash:-""} ${is_a_git_repo:-false} ${current_branch:-""} ${detached:-false} ${just_init:-false} ${has_upstream:-false} ${has_modifications:-false} ${has_modifications_cached:-false} ${has_adds:-false} ${has_deletions:-false} ${has_deletions_cached:-false} ${has_untracked_files:-false} ${ready_to_commit:-false} ${tag_at_current_commit:-""} ${is_on_a_tag:-false} ${has_upstream:-false} ${commits_ahead:-false} ${commits_behind:-false} ${has_diverged:-false} ${should_push:-false} ${will_rebase:-false} ${has_stashes:-false} ${action})"

}

function enrich_append {
    local flag=$1
    local symbol=$2
    local color=${3:-$omg_default_color_on}
    if [[ $flag == false ]]; then symbol=' '; fi

    echo -n "${color}${symbol}  "
}

function custom_git_prompt {
    local enabled=${1}
    local current_commit_hash=${2}
    local is_a_git_repo=${3}
    local current_branch=$4
    local detached=${5}
    local just_init=${6}
    local has_upstream=${7}
    local has_modifications=${8}
    local has_modifications_cached=${9}
    local has_adds=${10}
    local has_deletions=${11}
    local has_deletions_cached=${12}
    local has_untracked_files=${13}
    local ready_to_commit=${14}
    local tag_at_current_commit=${15}
    local is_on_a_tag=${16}
    local has_upstream=${17}
    local commits_ahead=${18}
    local commits_behind=${19}
    local has_diverged=${20}
    local should_push=${21}
    local will_rebase=${22}
    local has_stashes=${23}
    local action=${24}

    local prompt=""

    local red_on_black="%K{black}%F{red}"
    local white_on_black="%K{black}%F{white}"
    local yellow_on_black="%K{black}%F{yellow}"

    # Flags
    local omg_default_color_on="${white_on_black}"

    local current_path="%~"

    if [[ $is_a_git_repo == true ]]; then
        prompt="${PREFIX}${white_on_black} "
        # where
        if [[ $detached == true ]]; then
            prompt+=$(enrich_append $detached $omg_detached_symbol "${red_on_black}")
            prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${red_on_black}")
        else
            if [[ $has_upstream == false ]]; then
                prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${red_on_black}")
            else
                if [[ $will_rebase == true ]]; then
                    local type_of_upstream=$omg_rebase_tracking_branch_symbol
                else
                    local type_of_upstream=$omg_merge_tracking_branch_symbol
                fi

                if [[ $has_diverged == true ]]; then
                    prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${red_on_black}")
                else
                    if [[ $commits_behind -gt 0 ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} %F{white}${omg_can_fast_forward_symbol}%F{black} --" "${red_on_black}")
                    fi
                    if [[ $commits_ahead -gt 0 ]]; then
                        prompt+=$(enrich_append true "-- %F{white}${omg_should_push_symbol}%F{black}  +${commits_ahead}" "${red_on_black}")
                    fi
                    if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                         prompt+=$(enrich_append true " --   -- " "${red_on_black}")
                    fi

                fi
                prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${red_on_black}")
            fi
        fi
        # on filesystem
        prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${white_on_black}")
        prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${yellow_on_black}")
        prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${red_on_black}")
        prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${red_on_black}")
        prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${red_on_black}")

        # ready
        prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${white_on_black}")
        prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${white_on_black}")
        prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${white_on_black}")

        # next operation
        prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${red_on_black}")
        prompt+=$(enrich_append $action "${omg_has_action_in_progress_symbol} $action" "${red_on_black}")

        prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${red_on_black}")
        prompt+=${SUFFIX}
    fi
    echo "${prompt}"
}
