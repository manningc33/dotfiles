#!/usr/bin/env bash

dotfiles_dir=~/dotfiles

git pull origin master

function installHomebrew() {
	! command -v brew &>/dev/null && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	brew update
	brew upgrade

	pkgs=(
		bat
		eza
		fzf
		gcc
		git
		git-delta
		lazygit
		neofetch
		neovim
		node
		ripgrep
		starship
		stow
		tmux
		wget
		zoxide
	)

	brew install "${pkgs[@]}"
}

function installMisc() {
  # get bat and delta-git catppuccin theme
  echo "Getting bat and delta catppuccin themes if not present..."
  [ ! -f ~/.config/bat/themes/Catppuccin\ Mocha.tmTheme ] && wget -P ~/.config/bat/themes https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  [ ! -f ~/.local/share/catppuccin/delta/catppuccin.gitconfig ] && wget -P ~/.local/share/catppuccin/delta https://github.com/catppuccin/delta/raw/main/catppuccin.gitconfig

  # build bat themes 
  bat cache --build
}

function installApps() {
  installHomebrew
  installMisc
}

function createStowLinks() {
	mkdir -p "$HOME/.config"
	# stowing all modules
	stow_modules=(
		bash
		git
		nvim
		starship
		tmux
		# other
	)

	stow --adopt "${stow_modules[@]}"

	. ~/.profile
	. ~/.bashrc
}

function runSetup() {
	installApps
	createStowLinks
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	runSetup
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		runSetup
	fi
fi

echo "Dotfiles setup finish"

unset runSetup
unset installHomebrew
unset installMisc
unset installApps
unset createStowLinks
