#!/usr/bin/env bash

# It's assumed xcode and command line utils are installed
# install homebrew
which -s brew
if [[ $? != 0 ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# get some required packages
brew install zsh zsh-completions ctags wget git git-extras vim nvm
brew tap caskroom/cask
brew cask install java dockertoolbox atom

# remove outdated versions from the cellar.
brew cleanup

# remove outdated packages from homebrew && cask
brew cask cleanup

# setup some dotfiles
if [[ ! -f ~/.curlrc ]]; then
  ln -sfv ${PWD}/.curlrc ~/.curlrc
fi
if [[ ! -f ~/.gitconfig ]]; then
  ln -sfv ${PWD}/.gitconfig ~/.gitconfig
fi
if [[ ! -f ~/.gitignore_global ]]; then
  ln -sfv ${PWD}/.gitignore_global ~/.gitignore_global
fi
if [[ ! -f ~/.tern-config ]]; then
  ln -sfv ${PWD}/.tern-config ~/.tern-config
fi

# setup basic folders
mkdir -p ~/.atom
mkdir -p ~/.nvm
mkdir -p ~/.vim

# configure vim colors
if [[ ! -f ~/.atom/config.cson ]]; then
  ln -sfv ${PWD}/.atom/config.cson ~/.atom/config.cson
fi
if [[ ! -f ~/.atom/init.coffee ]]; then
  ln -sfv ${PWD}/.atom/init.coffee ~/.atom/init.coffee
fi
if [[ ! -f ~/.atom/keymap.cson ]]; then
  ln -sfv ${PWD}/.atom/keymap.cson ~/.atom/keymap.cson
fi
if [[ ! -f ~/.atom/snippets.cson ]]; then
  ln -sfv ${PWD}/.atom/snippets.cson ~/.atom/snippets.cson
fi
if [[ ! -f ~/.atom/styles.less ]]; then
  ln -sfv ${PWD}/.atom/styles.less ~/.atom/styles.less
fi

# symlink atom items

atomPackages=(
  "activate-power-mode"
  "advanced-new-file"
  "atom-beautify"
  "atom-ternjs"
  "autoclose-html"
  "autocomplete-paths"
  "docblockr"
  "file-icons"
  "git-history"
  "git-log"
  "git-plus"
  "icehunter-syntax"
  "language-dustjs"
  "linter"
  "linter-eslint"
  "node-debugger"
  "open-in-browser"
  "pigments"
  "react"
  "script"
  "turbo-javascript"
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

# get oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# configure zsh
if [[ ! -f ~/.zshrc ]]; then
  ln -sfv ${PWD}/.zshrc ~/.zshrc
fi
if [[ ! -f ~/.oh-my-zsh/themes/icehunter.zsh-theme ]]; then
  ln -sfv ${PWD}/.oh-my-zsh/themes/icehunter.zsh-theme ~/.oh-my-zsh/themes/icehunter.zsh-theme
fi

# configure vim
if [[ ! -f ~/.vimrc ]]; then
  ln -sfv ${PWD}/.vimrc ~/.vimrc
fi
if [[ ! -f ~/.vimrc.local ]]; then
  ln -sfv ${PWD}/.vimrc.local ~/.vimrc.local
fi

# configure vim colors
if [[ ! -f ~/.vim/colors/icehunter.vim ]]; then
  ln -sfv ${PWD}/.vim/colors/icehunter.vim ~/.vim/colors/icehunter.vim
fi
