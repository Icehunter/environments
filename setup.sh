#!/usr/bin/env bash

# create basic folders
mkdir -p ~/.atom
mkdir -p ~/.nvm
mkdir -p ~/.vim

# create base files
touch ~/.privates

cat ~/.privates | grep -q 'NPM_TOKEN'
if [[ $? != 0 ]]; then
  echo "export NPM_TOKEN=00000000-0000-0000-0000-000000000000" >> ~/.privates
fi

# delete dotfile's if they are already present but not symlinks
dotFiles=(
  ~/.curlrc
  ~/.gitconfig
  ~/.gitignore_global
  ~/.tern-config
  ~/.atom/config.cson
  ~/.atom/init.coffee
  ~/.atom/keymap.cson
  ~/.atom/snippets.cson
  ~/.atom/styles.less
  ~/.npmrc
  ~/.zshrc
  ~/.oh-my-zsh/themes/icehunter.zsh-theme
  ~/.vimrc
  ~/.vimrc.local
  ~/.vim/colors/icehunter.vim
)

for file in "${dotFiles[@]}"; do
  if [[ -f $file && ! -L $file ]]; then
    rm -f $file
  fi
  if [[ ! -f $file ]]; then
    customFile=${PWD}/$(awk "{gsub(\"${HOME}/\",\"\");print}" <<< "$file")
    ln -sfv $customFile $file
  fi
done

# install Xcode Command Line Tools (if not already)
if [[ ! -d /Library/Developer/CommandLineTools ]]; then
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" -v;
fi

# install homebrew
which -s brew
if [[ $? != 0 ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap caskroom/cask

brewInstalls=(
  bfg
  ctags
  git
  git-extras
  mongodb
  mysql
  nginx
  nvm
  python
  python3
  rabbitmq
  redis
  vim
  wget
  zsh
  zsh-completions
)

caskInstalls=(
  atom
  dockertoolbox
  java
)

# install some basic bundles form homebrew
for program in "${brewInstalls[@]}"; do
  brew install $program
done

# install some basic devtools
for program in "${caskInstalls[@]}"; do
  brew cask install $program
done

# remove outdated versions from the cellar.
brew cleanup

# remove outdated packages from homebrew && cask
brew cask cleanup

# install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# symlink atom items
atomPackages=(
  advanced-new-file
  atom-beautify
  atom-ternjs
  autoclose-html
  autocomplete-paths
  docblockr
  file-icons
  git-history
  git-log
  git-plus
  icehunter-syntax
  language-dustjs
  linter
  linter-eslint
  node-debugger
  open-in-browser
  pigments
  react
  script
  turbo-javascript
)

for package in "${atomPackages[@]}"; do
  if [[ ! -d ~/.atom/packages/$package ]]; then
    apm install $package
  fi
done

# ensure nvm
NVM_DIR=~/.nvm
. /usr/local/opt/nvm/nvm.sh

# set node to latest stable
nvm install stable
nvm alias default node
