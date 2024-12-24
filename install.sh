#!/bin/bash

if [ ! -z "$SUDO_USER" ]; then
  usr=$SUDO_USER
else
  usr=$(whoami)
fi

usr_home=$(getent passwd $usr | cut -d: -f6)
echo "usr home: $usr_home"

path=$(dirname "$(readlink -f "$0")")

check_package_installed() {
    local package="$1"  # 要检查的包名

    # 使用dpkg命令检查包是否已安装
    if dpkg -l | grep -qw "$package"; then
        echo "Package '$package' is installed."
    else
        echo "Package '$package' is not installed."
	apt-get install $package
    fi
}

update_zsh_plugin() {
  local t=$1
  local des="https://github.com/$2/$3.git"
  local dir=$path/modules/.oh-my-zsh/custom/$t/$3
  # 判断目录是否存在
if [ -d "$dir" ]; then
  pushd $dir
  git pull
  popd
else
  git clone $des $dir
fi
}

echo "install pkg..."
check_package_installed zsh
check_package_installed kitty
check_package_installed ranger

echo "init submodule..."
pushd $path
git submodule update --init --recursive
popd

update_zsh_plugin plugins zsh-users zsh-syntax-highlighting
update_zsh_plugin plugins zsh-users zsh-autosuggestions
update_zsh_plugin plugins zsh-users zsh-completions
update_zsh_plugin plugins zsh-users zsh-history-substring-search
update_zsh_plugin themes romkatv powerlevel10k

echo "stow config..."
stow -t ~/ config -v 3
echo "stow modules..."
stow -t ~/ modules -v 3

echo "configuring fzf..."
echo "DO NOT update your shell configuration files!"
su - $usr -c  '~/.fzf/install'

echo "set default zsh..."
su $usr -c 'chsh -s /usr/bin/zsh'