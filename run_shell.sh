#!/bin/bash

#################################################################
# filename              : run_shell.sh
# Author                : Brian Truong
# Version   Date        Description
# 1.0       May 26      Run bash script with permission execution
#
#
# Plans:
#       1. Run bash script
#       2. Run Python
#       3. Run C/C++
###############################################################################

# Check if shell script is executable and run it
run_shell(){
    if [ -x $1 ]; then
        ./$1 "${@:2}"
    else
        chmod +x $1
        ./$1 "${@:2}"
    fi
}

run_py(){
    echo "future development"
}

run_ccpp(){
    echo "future development"
}

# Check if the extension is .sh or .py or .c/.cpp
if [[ $1 == *.sh ]]; then
    run_shell "$@"
elif [[ $1 == *.py ]]; then
    run_py "$@"
elif [[ $1 == *(.c|.cpp) ]]; then
    run_ccpp "$@"
else
    echo "file extension is invalid"
fi


