#!/bin/bash

#################################################################
# filename              : run_shell.sh
# Author                : Brian Truong
# Version   Date        Description
# 1.0       May 26      Run bash script with permission execution
# 2.0       May 28      Run C/C++ filename
#                       Run Python filename
#
#
# Plans:
#       1. Run bash script
#       2. Run Python
#       3. Run C/C++
#################################################################

# Check if shell script is executable and run it
run_shell(){
    if [ -x $1 ]; then
        ./$1 "${@:2}"
    else
        chmod +x $1
        ./$1 "${@:2}"
    fi

    echo
    echo "Finished !!!"
}

run_py(){
    filename=$1
    arguments=${@:2}
    echo "---------------------------"
    echo "Running Python filename...."
    echo "---------------------------"
    echo
    python $1 ${@:2}
    echo
    echo "---------------------------"
    echo "Finished !!!"
    echo "---------------------------"
}

run_ccpp(){

    filename=$(basename -- "$1")
    extension="${filename##*.}"
    name="${filename%.*}"

    echo "Compiling $filename"
    echo "........."
    g++ "$1" -o $name

    echo "Running $filename"
    echo "........."
    echo
    ./$name "${@:2}"
    echo
    echo "Finished !!!"
}

# Check if the extension is .sh or .py or .c/.cpp
if [[ $1 == *.sh ]]; then
    run_shell "$@"
elif [[ $1 == *.py ]]; then
    run_py "$@"
elif [[ $1 == *.c ]]; then
    run_ccpp "$@"
elif [[ $1 == *.cpp ]]; then
    run_ccpp "$@"
else
    echo "file extension is invalid"
fi
