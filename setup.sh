#!/usr/bin/env bash 

dotfiles_dir=~/dotfiles

# git pull origin main 

function createLinks() {
  if [ ! -f /usr/local/bin/starship ]; then
    echo "Starship not found. Installing starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    # eval "$(starship init bash)" # sourcing .bashrc will do this 
  fi

  # remove files
  for dotfile in ~/.{bashrc,bash_aliases,vimrc,vim,config/nvim,config/starship.toml}; do
    rm -rf "$dotfile" > /dev/null 2>&1
  done 
  unset dotfile

  # link files in dot directory
  ln -nfs $dotfiles_dir/.bashrc ~/.bashrc
  ln -nfs $dotfiles_dir/.bash_aliases ~/.bash_aliases
  ln -nfs $dotfiles_dir/.vim ~/.vim
  ln -nfs $dotfiles_dir/.vim ~/.config/nvim
  ln -nfs ~/.vim/init.vim ~/.vimrc
  ln -nfs $dotfiles_dir/starship.toml ~/.config/starship.toml

  . ~/.bashrc

  echo -e "\n===== Summary =====\n"
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

