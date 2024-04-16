#!/bin/bash
stack_file=/tmp/windowAddressStack.txt
echo Hidden windows: $(wc -l $stack_file | awk '{print $1}')
