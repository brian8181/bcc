#!/bin/bash

LINE='\2'
COLUMN='\3'
ERROR='\4'
WARNING='\5'
CC_MSG='\8'

source "$HOME/bin/color.sh"
MSG="$FMT_FG_YELLOW $LINE : $COLUMN : $FMT_FG_RED $ERROR $FMT_FG_YELLOW $WARNING $FMT_RESET : $CC_MSG"

makecheck() {
    #make "$@" 2>&1 | tee tmp.txt | grep --color=always -E "error|fail|$"
    make "$@" 2>&1 | tee tmp.txt | sed -E "s|(^.*):([0-9]+)\.([0-9]+-[0-9]+):[ ]*(error)\|(warning)\|(note):(.*$)|$MSG|g"
    # sed -E "s|(^.*:)([0-9]+).([0-9]+\-[0-9]+): ([^:]+)(:.*)$|\1~\2~\3~~~~\4~~~~ ... \5|g"
}

