#!/bin/bash
# Half baked arch installation script

cd ~
sudo pacman -Syu
sudo pacman -S --needed base-devel htop btop eza zoxide ncdu ranger navi shellfirm thefuck clang npm rustup bpython neofetch xpra qterminal python-pywal go vim fzf zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -fsSL https://bun.sh/install | bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
yay -S tree-sitter-git neovim-git zig-dev-bin
git clone --recursive https://github.com/A-gmaE-programmer/dotfiles
cd dotfiles
./copyout.sh
