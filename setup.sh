#!/usr/bin/env bash 

dotfiles_dir=~/dotfiles

git pull origin master 

function createLinks() {
  # install fzf 
  echo ""
  echo "Installing fzf from github..."
  echo ""

  rm -rf ~/.local/share/fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.local/share/fzf" \
    && yes | "${HOME}/.local/share/fzf/install" --bin --no-update-rc

  echo ""
  echo ""

  if [ ! -f /usr/local/bin/starship ]; then
    echo "Starship not found. Installing starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    # eval "$(starship init bash)" # sourcing .bashrc will do this 
  else
    echo "Starship bin found."
  fi

  echo ""
  echo ""

  # Get bat catppuccin theme
  if [ ! -f ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme ]; then
    echo "Installing bat catppuccin theme from github..."
    mkdir -p ~/.config/bat/themes
    wget -P ~/.config/bat/themes https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  else 
    echo "Bat catppuccin theme already installed..."
  fi
  
  echo ""
  echo ""

  echo "Removing dotfiles from system..."
  # remove files
  for dotfile in ~/.{bashrc,bash_aliases,bash_profile,profile,vimrc,vim,config/nvim,config/starship.toml,tmux.conf}; do
    rm -rf "$dotfile" > /dev/null 2>&1
  done 
  unset dotfile

  echo ""
  echo ""

  echo "Linking dotfiles from repo..."
  # link files in dot directory
  ln -nfs $dotfiles_dir/.bashrc ~/.bashrc
  ln -nfs $dotfiles_dir/.bash_aliases ~/.bash_aliases
  ln -nfs $dotfiles_dir/.profile ~/.bash_profile
  ln -nfs $dotfiles_dir/.profile ~/.profile

  ln -nfs $dotfiles_dir/.tmux.conf ~/.tmux.conf
  ln -nfs $dotfiles_dir/.vim ~/.vim
  ln -nfs $dotfiles_dir/.vim ~/.config/nvim
  ln -nfs ~/.vim/init.vim ~/.vimrc
  ln -nfs $dotfiles_dir/starship.toml ~/.config/starship.toml

  . ~/.bashrc
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  createLinks  
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1 
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then 
    createLinks  
  fi
fi

echo "Dotfiles setup finish"

unset createLinks 

