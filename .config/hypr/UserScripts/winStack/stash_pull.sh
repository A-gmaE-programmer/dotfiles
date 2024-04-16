#!/bin/bash
stack_file=/tmp/windowAddressStack.txt
# Pull a windows from hidden window stack
address=$(tail -n 1 $stack_file)
activeworkspace=$(hyprctl activeworkspace | grep workspace | awk '{print $3}')
hyprctl dispatch movetoworkspacesilent $activeworkspace,address:0x$address
sed -i '$d' $stack_file
