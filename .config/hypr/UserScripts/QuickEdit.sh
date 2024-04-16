#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"
editor_old="kitty -e nano"
editor="qterminal -e vim"

menu(){
  printf "1. view Env-variables\n"
  printf "2. view Window-Rules\n"
  printf "3. view Startup_Apps\n"
  printf "4. view User-Keybinds\n"
  printf "5. view Monitors\n"
  printf "6. view Laptop-Keybinds\n"
  printf "7. view User-Settings\n"
  printf "8. view Default-Settings\n"
  printf "9. view Default-Keybinds\n"
}

main() {
    choice=$(menu | rofi -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
    case $choice in
        1)
            $editor "$UserConfigs/ENVariables.conf"
            ;;
        2)
            $editor "$UserConfigs/WindowRules.conf"
            ;;
        3)
            $editor "$UserConfigs/Startup_Apps.conf"
            ;;
        4)
            $editor "$UserConfigs/UserKeybinds.conf"
            ;;
        5)
            $editor "$UserConfigs/Monitors.conf"
            ;;
        6)
            $editor "$UserConfigs/Laptops.conf"
            ;;
        7)
            $editor "$UserConfigs/UserSettings.conf"
            ;;
        8)
            $editor "$configs/Settings.conf"
            ;;
        9)
            $editor "$configs/Keybinds.conf"
            ;;
        *)
            ;;
    esac
}

main
