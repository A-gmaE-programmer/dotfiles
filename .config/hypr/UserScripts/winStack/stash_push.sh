#!/bin/bash
stack_file=/tmp/windowAddressStack.txt
# Push a window to the hidden window stack
address=$(hyprctl activewindow | grep Window | awk '{print $2}')
echo $address >> $stack_file
hyprctl dispatch movetoworkspacesilent 20,address:0x$address
