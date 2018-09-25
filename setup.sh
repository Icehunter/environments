#!/usr/bin/env bash

# create basic folders
mkdir -p ~/.nvm
mkdir -p ~/.vim/colors
mkdir -p ~/.vscode/extensions
mkdir -p ~/Library/Application\ Support/Code/User

# create base files
touch ~/.privates

cat ~/.privates | grep -q 'NPM_TOKEN'

if [[ $? != 0 ]]; then
  echo "export NPM_TOKEN=00000000-0000-0000-0000-000000000000" >> ~/.privates
fi

. ~/.privates

# delete dotfile's if they are already present but not symlinks
dotFiles=(
  ~/.vim/colors/icehunter.vim
  ~/.oh-my-zsh/themes/icehunter.zsh-theme
  ~/.curlrc
  ~/.gitconfig
  ~/.gitignore_global
  ~/.npmrc
  ~/.tern-config
  ~/.vimrc
  ~/.vimrc.local
  ~/.zshrc
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

caskInstalls=(
  dotnet
  dotnet-sdk
  java
  visual-studio-code
)

brewInstalls=(
  bfg
  ctags
  git
  git-extras
  mono
  nginx
  nvm
  python
  python3
  redis
  vim
  wget
  zsh
  zsh-completions
)

# install some basic devtools
for program in "${caskInstalls[@]}"; do
  brew cask install $program
done

# install some basic bundles form homebrew
for program in "${brewInstalls[@]}"; do
  brew install $program
done

# remove outdated packages from homebrew && cask
brew cask cleanup

# remove outdated versions from the cellar.
brew cleanup

# setup vscode settings
ln -sfv ${PWD}/Code/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sfv ${PWD}/Code/vsicons.settings.json ~/Library/Application\ Support/Code/User/vsicons.settings.json

# setup vscode packages
codePackages=(
  alefragnani.project-manager
  christian-kohler.path-intellisense
  dbaeumer.vscode-eslint
  donjayamanne.githistory
  esbenp.prettier-vscode
  flowtype.flow-for-vscode
  formulahendry.code-runner
  icehunter.theme-icehunter
  icehunter.turbojavascript
  leopotam.csharpfixformat
  ms-vscode.csharp
  msjsdiag.debugger-for-chrome
  peterjausovec.vscode-docker
  robertohuertasm.vscode-icons
  siegebell.scope-info
  waderyan.gitblame
  xabikos.javascriptsnippets
  zignd.html-css-class-completion
)

for package in "${codePackages[@]}"; do
  if [[ ! -d ~/.vscode/extensions/$package ]]; then
    code --install-extension $package
  fi
done

# ensure nvm
NVM_DIR=~/.nvm
. /usr/local/opt/nvm/nvm.sh

# set node to latest stable
nvm install stable
nvm alias default node

# install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
