#!/bin/bash

git pull --recurse-submodules

declare -a configs=(bpython cava hypr nvim rofi wal waybar yad.conf)
declare -a others=(.zshrc .mozilla .p10k.zsh .vim .vimrc .zprofile)

for conf in "${configs[@]}"
do
  cp -r ./.config/$conf ~/.config/
done

for othr in "${others[@]}"
do
  cp -r ./$othr ~/
done

cp -r ./custom/ ~/.oh-my-zsh/
