#!/bin/bash

declare -a configs=(bpython cava hypr nvim rofi wal waybar yad.conf)
declare -a others=(.zshrc .oh-my-zsh/custom .p10k.zsh .vim .vimrc .zprofile)

for conf in "${configs[@]}"
do
  cp -r ~/.config/$conf ./.config/
done

for othr in "${others[@]}"
do
  cp -r ~/$othr ./
done
