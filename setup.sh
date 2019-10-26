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

# setup vscode settings
ln -sfv ${PWD}/Code/settings.json ~/.config/Code/User/settings.json
ln -sfv ${PWD}/Code/vsicons.settings.json ~/.config/Code/User/vsicons.settings.json

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
  flowtype.flow-for-vscode
  formulahendry.code-runner
  Icehunter.theme-icehunter
  Icehunter.TurboJavaScript
  johnpapa.vscode-peacock
  karigari.chat
  Leopotam.csharpfixformat
  ms-vscode.csharp
  ms-vsliveshare.vsliveshare
  ms-vsliveshare.vsliveshare-audio
  ms-vsliveshare.vsliveshare-pack
  msjsdiag.debugger-for-chrome
  PeterJausovec.vscode-docker
  PKief.material-icon-theme
  planbcoding.vscode-react-refactor
  VisualStudioExptTeam.vscodeintellicode
  Zignd.html-css-class-completion
)

for package in "${codePackages[@]}"; do
  if [[ ! -d ~/.vscode/extensions/$package ]]; then
    code --install-extension $package
  fi
done

# ensure nvm
NVM_DIR=~/.nvm
. $NVM_DIR/nvm.sh

# set node to latest stable
nvm install stable
nvm alias default node