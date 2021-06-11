# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="icehunter"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

if [[ ! -a ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ ! -a ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions ]]; then
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
fi

if [[ ! -a ~/.zsh-async ]]; then
  git clone https://github.com/mafredri/zsh-async.git ~/.zsh-async
fi

if [[ ! -a ~/.pure ]]; then
  git clone https://github.com/sindresorhus/pure.git ~/.pure
fi

if [[ ! -a ~/.dircolors ]]; then
  curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark --output ~/.dircolors
fi

# if [[ ! -a ~/.rbenv ]]; then
#     git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# fi

plugins=(common-aliases git git-extras zsh-autosuggestions zsh-completions)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

. $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# helper application calls
alias web="python -m SimpleHTTPServer"

# few little useful aliases
alias md="mkdir -pv"
alias get="wget -c"
alias vi="vim"
alias e="tar -xvf"
alias up="sudo apt update && sudo apt upgrade && omz update"

function code () {
  if [[ $# -eq 0 ]]; then
    /mnt/c/Users/Icehunter/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code .
  else
    /mnt/c/Users/Icehunter/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code $@
  fi
}

function kn () {
  killall node
}

function kp () {
  sudo kill -9 $(sudo lsof -t -i:$@)
}

# docker
# kill
function dkill () {
  if [[ ! -z $(docker ps -q) ]]; then
    docker kill $(docker ps -q)
  fi
}

# kill and delete containers/images
function dclean () {
  dkill
  docker system prune -f
}

# docker-compose up shorthand
function dcup () {
  docker-compose up $@
}

function nvmi () {
  nvm install $@ --reinstall-packages-from=$(node --version)
}

function nup () {
  npx npm-check -u
}

function yup () {
  npx yarn-check -u
}

function clone () {
  case $1 in
    move|tile)
      key="id_ed25519_$1"
      echo "cloning using key: $key"
      GIT_SSH_COMMAND="ssh -i ~/.ssh/$key" git clone $2
      ;;
    *)
      git clone $1
      ;;
  esac
}

function gs () {
  case $1 in
    move|tile)
      key="id_ed25519_$1"
      echo "setting config to use key: $key"
      git config --local core.sshCommand "ssh -i ~/.ssh/$key"
      ;;
  esac
}

function fzh () {
  cd ~
  mv .zsh_history .zsh_history_bad
  strings .zsh_history_bad > .zsh_history
  fc -R .zsh_history
}

# grep options
export GREP_COLOR="0;32"

# terminal options
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

paths=(
  /usr/local/go/bin
  ~/.nvm/versions/node/v14.15.1/bin
  # ~/.rbenv/bin
  /mnt/c/Users/Icehunter/AppData/Local/Programs/Microsoft\ VS\ Code/bin
  /mnt/c/Windows/System32/WindowsPowerShell/v1.0/
)

export PATH="$(IFS=:; echo "${paths[*]}"):$PATH"

eval $(thefuck --alias)

. ~/.zsh-async/async.zsh

fpath+=("$HOME/.pure")
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color yellow
prompt pure

export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh" --no-use

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  command -v nvm >/dev/null 2>&1 || return;

  local node_version="$(nvm version)"
  local nvmrc_path=".nvmrc"

  if [ -f "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc

eval `dircolors ~/.dircolors`
# eval "$(rbenv init -)"

# export DOCKER_HOST=tcp://localhost:2375

# Note: Bash on Windows does not currently apply umask properly.
if [[ "$(umask)" = "0000" ]]; then
  umask 0022
fi

# Start docker daemon automatically when logging in if not running.
RUNNING_DOCKER=`ps aux | grep dockerd | grep -v grep`
if [ -z "$RUNNING_DOCKER" ]; then
    sudo service docker start
fi

# Start mysql daemon automatically when logging in if not running.
#RUNNING_MYSQL=`ps aux | grep mysqld | grep -v grep`
#if [ -z "$RUNNING_MYSQL" ]; then
#    sudo service mysql start
#fi

# Start redis daemon automatically when logging in if not running.
#RUNNING_REDIS=`ps aux | grep redis | grep -v grep`
#if [ -z "$RUNNING_REDIS" ]; then
#    sudo service redis-server start
#fi

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
