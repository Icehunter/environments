#!/usr/bin/env bash

# create basic folders
mkdir -p ~/.nvm
mkdir -p ~/.vim/colors
mkdir -p ~/.vscode/extensions
mkdir -p ~/Library/Application\ Support/Code/User

# # create base files
# touch ~/.privates

# cat ~/.privates | grep -q 'NPM_TOKEN'

# if [[ $? != 0 ]]; then
#   echo "export NPM_TOKEN=00000000-0000-0000-0000-000000000000" >> ~/.privates
# fi

# . ~/.privates

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
  ~/.yarnrc
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

brew tap homebrew/fonts
brew tap homebrew/cask

caskInstalls=(
  font-fira-code
  visual-studio-code
  dotnet-sdk
  java
  ngrok
)

brewInstalls=(
  bfg
  ctags
  git
  git-extras
  mono
  nvm
  python
  python3
  redis
  thefuck
  vim
  watchman
  wget
  zsh
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
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  CoenraadS.bracket-pair-colorizer
  cschlosser.doxdocgen
  dbaeumer.vscode-eslint
  eamodio.gitlens
  eg2.vscode-npm-script
  esbenp.prettier-vscode
  formulahendry.auto-rename-tag
  Icehunter.theme-icehunter
  Icehunter.TurboJavaScript
  johnpapa.vscode-peacock
  karigari.chat
  Leopotam.csharpfixformat
  ms-azuretools.vscode-docker
  ms-vscode.csharp
  ms-vsliveshare.vsliveshare
  ms-vsliveshare.vsliveshare-audio
  ms-vsliveshare.vsliveshare-pack
  msjsdiag.debugger-for-chrome
  PKief.material-icon-theme
  planbcoding.vscode-react-refactor
  redhat.java
  VisualStudioExptTeam.vscodeintellicode
  vscjava.vscode-java-debug
  vscjava.vscode-java-dependency
  vscjava.vscode-java-pack
  vscjava.vscode-java-test
  vscjava.vscode-maven
  Zignd.html-css-class-completion
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
