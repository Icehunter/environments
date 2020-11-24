#!/usr/bin/env bash

# create basic folders
mkdir -p ~/.nvm
mkdir -p ~/.vim/colors
mkdir -p ~/.vscode/extensions
mkdir -p ~/.config/Code/User

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
# codePackages=(
#   alefragnani.project-manager
#   amatiasq.sort-imports
#   christian-kohler.npm-intellisense
#   christian-kohler.path-intellisense
#   CoenraadS.bracket-pair-colorizer
#   cschlosser.doxdocgen
#   dbaeumer.vscode-eslint
#   dsteenman.cloudformation-yaml-snippets
#   eamodio.gitlens
#   eg2.vscode-npm-script
#   esbenp.prettier-vscode
#   flowtype.flow-for-vscode
#   formulahendry.code-runner
#   Icehunter.theme-icehunter
#   Icehunter.TurboJavaScript
#   johnpapa.vscode-peacock
#   karigari.chat
#   Leopotam.csharpfixformat
#   ms-dotnettools.csharp
#   ms-vscode-remote.remote-wsl
#   ms-vscode.powershell
#   ms-vsliveshare.vsliveshare
#   ms-vsliveshare.vsliveshare-audio
#   ms-vsliveshare.vsliveshare-pack
#   msjsdiag.debugger-for-chrome
#   PKief.material-icon-theme
#   planbcoding.vscode-react-refactor
#   redhat.java
#   silvenon.mdx
#   SonarSource.sonarlint-vscode
#   VisualStudioExptTeam.vscodeintellicode
#   vscjava.vscode-java-debug
#   vscjava.vscode-java-dependency
#   vscjava.vscode-java-pack
#   vscjava.vscode-java-test
#   vscjava.vscode-maven
#   wingrunr21.vscode-ruby
#   wix.vscode-import-cost
#   Zignd.html-css-class-completion
# )

# for package in "${codePackages[@]}"; do
#   if [[ ! -d ~/.vscode/extensions/$package ]]; then
#     code --install-extension $package
#   fi
# done

# # ensure nvm
# NVM_DIR=~/.nvm
# . $NVM_DIR/nvm.sh

# # set node to latest stable
# nvm install 12
# nvm alias default node
