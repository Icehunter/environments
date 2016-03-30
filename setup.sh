#!/usr/bin/env bash

# It's assumed xcode and command line utils are installed
# install homebrew
which -s brew
if [[ $? != 0 ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# get some required packages
brew install bash bash-completion zsh zsh-completions ctags wget git git-extras vim nvm
brew tap caskroom/cask
brew cask install java dockertoolbox

# ensure nvm
mkdir -p ~/.nvm
NVM_DIR=~/.nvm
. /usr/local/opt/nvm/nvm.sh

# set node to latest stable
nvm install stable
nvm alias default node

# get oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [[ ! -f ~/.curlrc ]]; then
  ln -sfv ${PWD}/.curlrc ~/.curlrc
fi

if [[ ! -f ~/.gitconfig ]]; then
  ln -sfv ${PWD}/.gitconfig ~/.gitconfig
fi

if [[ ! -f ~/.gitignore_global ]]; then
  ln -sfv ${PWD}/.gitignore_global ~/.gitignore_global
fi

if [[ ! -f ~/.vimrc ]]; then
  ln -sfv ${PWD}/.vimrc ~/.vimrc
fi

if [[ ! -f ~/.zshrc ]]; then
  ln -sfv ${PWD}/.zshrc ~/.zshrc
fi

if [[ ! -f ~/.oh-my-zsh/themes/icehunter.zsh-theme ]]; then
  ln -sfv ${PWD}/.oh-my-zsh/themes/icehunter.zsh-theme ~/.oh-my-zsh/themes/icehunter.zsh-theme
fi

if [[ ! -f ~/.vim/colors/icehunter.vim ]]; then
  ln -sfv ${PWD}/.vim/colors/icehunter.vim ~/.vim/colors/icehunter.vim
fi
