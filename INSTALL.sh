#!/bin/sh
# -*- mode: bash; tab-width: 4; indent-tabs-mode: nil; -*-
# yanuart.adityan[at]gmail.com

set -e

# Version compare.
version_lt() {
	! printf '%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

install_ubuntu() {
	local UBUNTU_VER_MIN=20.04
	local UBUNTU_VER=$(lsb_release -rs)
	if version_lt "${UBUNTU_VER}" "${UBUNTU_VER_MIN}"; then
		echo "*** Ubuntu ${UBUNTU_VER} is not supported. Upgrade to at least ${UBUNTU_VER_MIN}!"
		exit 1
	fi

	sudo apt-get -y update
	sudo apt-get -y install \
		build-essential \
		clang-format \
		clang-tidy \
		cmake \
		cmake-data \
		curl \
		doxygen \
		git \
		ninja-build \
		pandoc \
		plantuml \
		python3-pip \
		valgrind
}

install_arch() {
	echo "INSTALLING FOR ARCH..."
	sudo pacman -Syyu --noconfirm
	sudo pacman -S --noconfirm \
		base-devel \
		clang \
		clang-format \
		cmake \
		cmake-data \
		curl \
		doxygen \
		git \
		ninja \
		plantuml \
		pandoc \
		python-pip \
		valgrind
}

brew_install() {
	# Install Homebrew if it's not already installed.
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew is not installed on this system. It will be used for"
		echo "installing missing software. See: https://brew.sh/"
		while true; do
			local yn
			read -p "Install Homebrew [y/n]? " yn
			case $yn in
			[Yy]*) break ;;
			[Nn]*)
				echo "*** Aborting!"
				exit 1
				;;
			*) echo "Please answer yes or no." ;;
			esac
		done

		# This is the recommended method according to https://brew.sh/
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi

	# Install the requested package.
	brew install "$1"
}

install_macos() {
	# Experimental
	echo "MACOS is experimental."

	if ! command -v cmake >/dev/null 2>&1; then
		brew_install cmake
	fi

	if ! command -v mono >/dev/null 2>&1; then
		brew_install mono
	fi

	if ! command -v ninja >/dev/null 2>&1; then
		brew_install ninja
	fi

	if ! command -v pip3 >/dev/null 2>&1; then
		brew_install python3
	fi

	if ! command -v xcodebuild >/dev/null 2>&1; then
		echo "NOTE: Install Xcode CLI tool!"
	fi
}

install_unknown() {
	echo "WARNING: System not recognized or running Windows."
	echo "Bye Bye"
}

# Main entry.
install_deps() {
	# Check distribution and package manager to use.
	if [ "$(uname -s)" = "Linux" ]; then
		#! NOTE: Linux FTW.
		if command -v apt-get >/dev/null 2>&1; then
			install_ubuntu
		elif command -v yum >/dev/null 2>&1; then
			#! TODO: Add install_redhat
			install_redhat
		elif command -v pacman >/dev/null 2>&1; then
			install_arch
		else
			install_unknown
		fi
	elif [ "$(uname -s)" = "Darwin" ]; then
		#! NOTE: MacOS okej la.
		install_macos
	else
		#! NOTE: Others.
		echo "Sorry use UNIX, preferably Linux"
	fi
}

install_alacritty() {
	# Install Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup override set stable
	rustup update stable

	# Install Alacritty
	if command ls ~/Workspace >/dev/null 2>&1; then
		mkdir ~/Workspace/github/alacritty
	fi

	git clone git clone https://github.com/alacritty/alacritty.git ~/Workspace/github/alacritty
	sudo apt install -y \
		pkg-config \
		libfreetype6-dev \
		libfontconfig1-dev \
		libxcb-xfixes0-dev \
		libxkbcommon-dev

	local curr_dir=$(pwd)
	cd ~/Workspace/github/alacritty && cargo build --release

	# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#install-the-rust-compiler-with-rustup
	if command infocmp alacritty >/dev/null 2>&1; then
		sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
	fi

	# Add Alacritty to the desktop entry
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database

	# Copy config
	if command ls ~/.config >/dev/null 2>&1; then
		mkdir ~/.config/alacritty
	fi
	cd "${curr_dir}"
	cp ./dotfiles/alacritty.yml ~/.config/alacritty
}

install_zsh() {
	# Install Zsh
	echo "Installing ZSH and Oh-My-Zsh"
	sudo apt-get install -y zsh
	# Set default bash to zsh
	chsh -s $(which zsh)
	# Install Oh-My-Zsh
	local USERNAME=$(whoami)
	echo "checking /home/${USERNAME}/.oh-my-zsh"
	if [ ! -d "/home/${USERNAME}/.oh-my-zsh"]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
	# Copy the .zshrc setting
	cp ./dotfiles/.zshrc ./dotfiles/.zsh_aliases ~/
	# Install zsh-autosuggestions
	if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"]; then
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	fi
}

install_vim() {
	# Install Vim
	sudo apt-get install -y vim
	cp ./dotfiles/.vimrc ~/
	if [ ! -d "${HOME}/.vim/bundle/Vundle.vim"]; then
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
	vim +PluginInstall +qall
}

install_tmux() {
	# Install Tmux
	sudo apt install -y tmux
	cp ./dotfiles/.tmux.conf ~/
	tmux source ~/.tmux.conf
}

install_vscode() {
	# Install VSCode
	if command ls ~/Downloads/Installer >/dev/null 2>&1; then
		mkdir ~/Downloads/Installer
	fi
	wget https://code.visualstudio.com/sha/download?build=stable &
	os=linux-deb-x64 -O ~/Downloads/Installer/code.deb
	sudo dpkg -i ~/Downloads/Installer/code.deb
	if command ls ~/.config/Code >/dev/null 2>&1; then
		mkdir ~/.config/Code/User
	fi
	cp ./vscode/* ~/.config/Code/User/
}

# Install applications.
install_alias() {
	# Alias
	cp ./dotfiles/.zsh_aliases ~/
	cp ./dotfiles/.bash_aliases ~/

	if [ -d "${HOME}/.zshrc" ]; then
		. ${HOME}/.zshrc
	fi
}

# Install fonts.
install_fonts() {
	# Fonts
	local font1="JetBrainsMono"
	local font2="FantasqueSansMono"

	echo "Getting ${font1} Nerd Font Complete..."
	curl -fLo "/tmp/${font1}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/${font1}.zip"
	echo "Getting ${font2} Nerd Font Complete..."
	curl -fLo "/tmp/${font2}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/${font2}.zip"

	if ! command -v unzip >/dev/null 2>&1; then
		sudo apt install unzip
	fi

	unzip /tmp/${font1}.zip -d ~/.fonts/
	unzip /tmp/${font2}.zip -d ~/.fonts/
}

install() {
	if [ $1 = "all" ] || [ $1 = "deps" ]; then
		echo "Installing Dependencies..."
		install_deps
	fi

	if [ $1 = "all" ] || [ $1 = "zsh" ]; then
		echo "Installing ZSH..."
		install_zsh
	fi

	if [ $1 = "all" ] || [ $1 = "vim" ]; then
		echo "Installing Vim..."
		install_vim
	fi

	if [ $1 = "all" ] || [ $1 = "alacritty" ]; then
		echo "Installing Alacritty..."
		install_alacritty
	fi

	if [ $1 = "all" ] || [ $1 = "tmux" ]; then
		echo "Installing Tmux..."
		install_tmux
	fi

	if [ $1 = "all" ] || [ $1 = "vscode" ]; then
		echo "Installing VSCode..."
		install_vscode
	fi

	if [ $1 = "all" ] || [ $1 = "alias" ]; then
		echo "Installing Alias..."
		install_alias
	fi

	if [ $1 = "all" ] || [ $1 = "font" ]; then
		echo "Installing Fonts..."
		install_fonts
	fi
}

install $1
