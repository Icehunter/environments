#!/usr/bin/env bash
sudo apt update
sudo apt upgrade -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    zsh \
    python3-dev \
    python3-pip \
    python3-setuptools

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo pip3 install thefuck

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

sudo gpasswd -a $USER docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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
codePackages=(
  alefragnani.project-manager
  amatiasq.sort-imports
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
  ms-azuretools.vscode-azurefunctions
  ms-azuretools.vscode-azureresourcegroups
  ms-dotnettools.csharp
  ms-vscode-remote.remote-wsl
  ms-vscode.azure-account
  ms-vscode.powershell
  ms-vsliveshare.vsliveshare
  ms-vsliveshare.vsliveshare-audio
  ms-vsliveshare.vsliveshare-pack
  PKief.material-icon-theme
  redhat.java
  silvenon.mdx
  VisualStudioExptTeam.vscodeintellicode
  vscjava.vscode-java-debug
  vscjava.vscode-java-dependency
  vscjava.vscode-java-pack
  vscjava.vscode-java-test
  vscjava.vscode-maven
  wix.vscode-import-cost
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
