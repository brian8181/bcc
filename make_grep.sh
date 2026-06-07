#!/bin/bash

LINE='\1'
COLUMN='\2'
ERROR='\3'
WARNING='\4'
CC_MSG='\7'

source "$HOME/bin/color.sh"
MSG="$FMT_FG_YELLOW $LINE : $COLUMN : $FMT_FG_RED $ERROR $FMT_FG_YELLOW $WARNING $FMT_RESET : $CC_MSG"

makecheck() {
    #make "$@" 2>&1 | tee tmp.txt | grep --color=always -E "error|fail|$"
    make "$@" 2>&1 | tee tmp.txt | sed -E "s|(^.*):([0-9]+)\.([0-9]+-[0-9]+):[ ]*(error)\|(warning)\|(note):(.*$)|$MSG|g"
    # sed -E "s|(^.*:)([0-9]+).([0-9]+\-[0-9]+): ([^:]+)(:.*)$|\1~\2~\3~~~~\4~~~~ ... \5|g"
}

