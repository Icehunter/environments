# oh-my-zsh Icehunter Theme

### Custom Colors
local ORANGE=$FG[214]

### LF
local LF=$'\n'

### Git
local BRANCH_ICON="\ue0a0"

ZSH_THEME_GIT_PROMPT_PREFIX="${ORANGE}["
ZSH_THEME_GIT_PROMPT_SUFFIX="$ORANGE]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_AHEAD=""
ZSH_THEME_GIT_PROMPT_BEHIND=""
ZSH_THEME_GIT_PROMPT_STAGED=""
ZSH_THEME_GIT_PROMPT_UNSTAGED=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""

icehunter_is_repo () {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    return 0
  fi
  return 1
}

### Git Helpers
icehunter_git_branch () {
  if icehunter_is_repo; then
    local BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    local COMMIT_HASH=$(git rev-parse HEAD 2> /dev/null)
    local UPSTREAM=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
    if [[ -n "${UPSTREAM}" && "${UPSTREAM}" != "@{UPSTREAM}" ]]; then local HAS_UPSTREAM=true; fi
    if [[ $HAS_UPSTREAM == true ]]; then
        local DIFF="$(git log --pretty=oneline --topo-order --left-right ${COMMIT_HASH}...${UPSTREAM} 2> /dev/null)"
        local AHEAD=$(\grep -c "^<" <<< "$DIFF")
        local BEHIND=$(\grep -c "^>" <<< "$DIFF")
    fi
    if [[ $AHEAD -eq 0 && $BEHIND -eq 0 ]]; then
      echo "%{$fg_bold[cyan]%}$BRANCH_NAME%{$reset_color%}" && return
    fi
    if [[ $AHEAD -gt 0 && $BEHIND -gt 0 ]]; then
      echo "$ORANGE$BRANCH_NAME%{$reset_color%}" && return
    fi
    if [[ $AHEAD -gt 0 ]]; then
      echo "%{$fg[green]%}$BRANCH_NAME%{$reset_color%}" && return
    fi
    if [[ $BEHIND -gt 0 ]]; then
      echo "%{$fg_bold[red]%}$BRANCH_NAME%{$reset_color%}" && return
    fi
  fi
}

icehunter_git_status () {
  if icehunter_is_repo; then
    local GIT_INDEX="$(git status --porcelain -b 2> /dev/null)"
    local STASHED=$(git stash list 2> /dev/null | wc -l | sed -e 's/^[ \t]*//')

    local REPO_STATUS=""
    local INDEXED=""
    local WORKING=""

    # index counters
    local INDEX_ADDED=$(echo "$GIT_INDEX" | grep -c '^A')
    local INDEX_MODIFIED=$(echo "$GIT_INDEX" | grep -c -E '^[MR]')
    local INDEX_DELETED=$(echo "$GIT_INDEX" | grep -c '^D')
    local INDEX_CONFLICT=$(echo "$GIT_INDEX" | grep -c '^U')

    # working tree counters
    local UNTRACKED=$(echo "$GIT_INDEX" | grep -c -E '^[\?A][\?A] ')

    local WORKING_MODIFIED=$(echo "$GIT_INDEX" | grep -c -E '^[A-Z ][MR] ')
    local WORKING_DELETED=$(echo "$GIT_INDEX" | grep -c -E '^[A-Z ]D ')
    local WORKING_CONFLICT=$(echo "$GIT_INDEX" | grep -c '^[A-Z ]U ')

    # index
    if [[ $INDEX_ADDED -gt 0 ]]; then
      INDEXED=" +$INDEX_ADDED"
    fi
    if [[ $INDEX_MODIFIED -gt 0 ]]; then
      INDEXED="$INDEXED ~$INDEX_MODIFIED"
    fi
    if [[ $INDEX_DELETED -gt 0 ]]; then
      INDEXED="$INDEXED -$INDEX_DELETED"
    fi
    if [[ $INDEX_CONFLICT -gt 0 ]]; then
      INDEXED="$INDEXED !$INDEX_CONFLICT"
    fi

    # working directory
    if [[ $UNTRACKED -gt 0 ]]; then
      WORKING=" +$UNTRACKED"
    fi
    if [[ $WORKING_MODIFIED -gt 0 ]]; then
      WORKING="$WORKING ~$WORKING_MODIFIED"
    fi
    if [[ $WORKING_DELETED -gt 0 ]]; then
      WORKING="$WORKING -$WORKING_DELETED"
    fi
    if [[ $WORKING_CONFLICT -gt 0 ]]; then
      WORKING="$WORKING !$WORKING_CONFLICT"
    fi

    if [[ $INDEXED != "" ]]; then
      INDEXED="%{$fg_bold[green]%}$INDEXED"
    fi
    if [[ $WORKING != "" ]]; then
      WORKING="%{$fg_bold[red]%}$WORKING"
    fi

    if [[ $INDEXED != "" && $WORKING != "" ]]; then
      REPO_STATUS="$INDEXED $ORANGE|$WORKING"
    else
      REPO_STATUS="$INDEXED$WORKING"
    fi

    if [[ $STASHED -gt 0 ]]; then
      REPO_STATUS="$REPO_STATUS $ORANGE*$STASHED"
    fi
    echo "$REPO_STATUS"
  fi
}

icehunter_git_prompt () {
  if icehunter_is_repo; then
    echo "%{$reset_color%}$(icehunter_git_branch)%{$reset_color%}$(icehunter_git_status)%{$reset_color%}"
  else
    echo "%{$reset_color%}"
  fi
}

icehunter_git_prompt_short () {
  if icehunter_is_repo; then
    echo "%{$reset_color%}$(icehunter_git_status)%{$reset_color%}"
  else
    echo "%{$reset_color%}"
  fi
}

icehunter_git_prompt_wrapped () {
  if icehunter_is_repo; then
    echo "%{$reset_color%}$ZSH_THEME_GIT_PROMPT_PREFIX%{$reset_color%}$(icehunter_git_branch)%{$reset_color%}$(icehunter_git_status)%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX%{$reset_color%}"
  else
    echo "%{$reset_color%}"
  fi
}

### Prompt Helpers
icehunter_get_space () {
  local DATA=$1$2
  local ZERO='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)DATA//$~ZERO/}}
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done
  echo $SPACES
}

icehunter_shorten_path () {
    local PRE=""
    local NAME="$1"
    local LENGTH="$2";
    [[ "$NAME" != "${NAME#$HOME/}" || -z "${NAME#$HOME}" ]] && PRE+='~' NAME="${NAME#$HOME}" LENGTH=$[LENGTH-1];
    ((${#NAME}>$LENGTH)) && NAME="/...${NAME:$[${#NAME}-LENGTH+4]}";
    echo "$PRE$NAME"
}

### Prompt
local PROMPT_STATUS="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"

PROMPT='${PROMPT_STATUS} %{$fg[yellow]%}%~ $(icehunter_git_prompt_wrapped)${LF} ↳ '
RPROMPT=""
