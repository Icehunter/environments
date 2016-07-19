# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="icehunter"

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
plugins=(common-aliases docker git git-extras npm)

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

# zsh completions
fpath=(/usr/local/share/zsh-completions $fpath)

# helper application calls
alias atom="atom ."
alias finder="open ."
alias tower="gittower ."
alias pweb="python -m SimpleHTTPServer"

# force spotlight re-index
alias sri="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"

# few little useful aliases
alias mkdir="mkdir -pv"
alias wget="wget -c"

# docker

# kill
dkill () {
  if [[ ! -z $(docker ps -q) ]]; then
    docker kill $(docker ps -q)
  fi
}

# delete all stopped containers
drm () {
  if [[ ! -z $(docker ps -a -q) ]]; then
    docker rm $(docker ps -a -q)
  fi
}

# delete images, default "none", but can do everything
drmi () {
  if [[ $1 == '--all' ]]; then
    if [[ ! -z $(docker images -q) ]]; then
      docker rmi -f $(docker images -q)
    fi
  else
    if [[ ! -z $(docker images | grep "^<none>" | awk "{print $3}") ]]; then
      docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
    fi
  fi
}

# kill and delete containers/images
dclean () {
  dkill $@
  drm $@
  drmi $@
}

# docker-machine
dm () {
  docker-machine $@
}

dmr () {
  dm restart default
}

# docker-compose up shorthand
dcup () {
  docker-compose up $@
}

# update development env
devup () {
  brew update
  brew upgrade

  apps=(/usr/local/Caskroom/*)
  for app in "${apps[@]}"; do
    brew cask install $(awk '{gsub("/usr/local/Caskroom/","");print}' <<< "$app")
  done

  brew cleanup
  brew cask cleanup
  yes | apm update
}

alias vi="vim"

# grep options
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="0;32"

# terminal options
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

typeset -A customPaths

customPaths[GOPATH]=~/Development/go
customPaths[KITEMATIC]='/Applications/Docker/Kitematic\ \(Beta\).app/Contents/Resources/resources'
customPaths[ANDROID_SDK]=~/Downloads/android-sdk-macosx
customPaths[LOCAL_SBIN]='/usr/local/sbin'

for key in "${(@k)customPaths}"; do
  export $key=$customPaths[$key]
  export PATH=$customPaths[$key]:$PATH
done

export PATH=$GOPATH/bin:$PATH

# docker exports
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH=~/.docker/machine/machines/default
export DOCKER_MACHINE_NAME="default"

# uncommited stuffies
. ~/.privates

# nvm setup
export NVM_DIR=~/.nvm
. /usr/local/opt/nvm/nvm.sh
