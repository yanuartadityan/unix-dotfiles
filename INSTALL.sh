#!/bin/sh
# -*- mode: bash; tab-width: 4; indent-tabs-mode: nil; -*-

set -e 

# Version compare.
version_lt() {
  ! printf '%s\n' "$2" "$1" | sort --check=quiet --version-sort
}

install_ubuntu() {
  local UBUNTU_VER_MIN=20.04
  local UBUNTU_VER=$(lsb_release -rs)
  if version_lt "${UBUNTU_VER}" "{UBUNTU_VER_MIN}"; then
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
                [Yy]* ) break;;
                [Nn]* ) echo "*** Aborting!"; exit 1;;
                * ) echo "Please answer yes or no.";;
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
main() {
  # Check distribution and package manager to use.
  if [ "$(uname -s)" = "Linux" ]; then
    #! NOTE: Linux FTW.
    if command -v apt-get >/dev/null 2>&1; then
      install_ubuntu
    if command -v yum >/dev/null 2>&1; then
      #! TODO: Add install_redhat
      install_redhat
    if command -v pacman >/dev/null 2>&1; then
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
# }

main
