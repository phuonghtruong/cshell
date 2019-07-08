#!/bin/bash

#################################################################
# filename              : run_shell.sh
# Author                : Brian Truong
# Version   Date        Description
# 1.0       May 26      Run bash script with permission execution
# 2.0       May 28      Run C/C++ filename
#                       Run Python filename
# 3.0       Jun 17      Run Java filename
# 3.1       Jun 25      Notify testcase failed due to segmentation fault
#
# Plans:
#       1. Create makefile for C/C++ when compiling multi-files and link them -> done
#       2. Run Python from Jupyter Notebook -> Done
#       3. Run C/C++ -> done
#################################################################

# Define color for text
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

filename=$(basename -- "$1")
name="${filename%.*}"
extension=$([[ "$filename" = *.* ]] && echo ".${filename##*.}" || echo '')
logfile="$name".log

# Check if shell script is executable and run it
run_shell(){
    if [ -x $filename ]; then
        echo "--- RUNNING ---"
        echo
        ./$filename "${@:2}"
    else
        echo "--- SETTING UP PERMISSION ---"
        chmod +x $filename
        echo "--- RUNNING ---"
        ./$filename "${@:2}"
    fi

    echo
    echo -e "--- ${GREEN}FINISHED !!!${NC} ---"
    echo
}

run_py(){
    # Python extension
    if [[ $extension == '.py' ]]; then

        echo "--- Running $filename ---"
        echo
        python $filename ${@:2}
        echo
        echo -e "--- ${GREEN}Finished !!! ---"
    # Python Jupyter Notebook
    elif [[ $extension == '.ipynb' ]]; then
        echo '''
        This file is Python Notebook from Jupyter
        Some components need to be install below
        > pip install nbconvert --user
        > pip install jupyter --user
        '''
        # Convert .ipynb to .py
        echo "--- START CONVERTINT TO $name.py ---"
        jupyter nbconvert --to python $filename
        echo -e "--- ${GREEN}CONVERTING DONE${NC} ---"

        # Run .ipynb
        ipython3 "$name.py"
        echo
        echo -e "--- ${GREEN}FINISHED !!!${NC} ---"

    fi
}

run_ccpp(){
    # check if object file is exist.
    if [[ -f "output" ]]; then
        echo "Deleting existing object file ....."
        echo
        rm -rf ./output
    fi

    # check if previous logfile is exist
    if [[ -f "$logfile" ]]; then
        echo "Deleting existing log file $logfile ....."
        echo
        rm -rf ./$logfile
    fi

    # Divide it to run all / run alone and clean
    echo "--- COMPILING ---"
    if [[ $extension == '.c' ]]; then
        g++ *.c -o output 2> $logfile
    elif [[ $extension == '.cpp' ]]; then
        g++ *.cpp -o output 2> $logfile
    fi

    # Check if there is Error in compilation log
    if egrep -qE "(error|undefined)" $logfile ; then
        echo
        echo -e "*** ${RED}COMPILED ERROR !!!${NC} ***"
        cat $logfile | egrep "(error|undefined)"
        exit 1
    else
        if grep -q "warning" $logfile ; then
            echo
            echo -e "*** ${YELLOW}WARNING !!!${NC} ***: Have a look !!!!"
            cat $logfile | grep "warning"
        fi

        echo "--- RUNNING ---"
        echo
        ./output |& tee -a $logfile
        echo
        if grep -q "fault" $logfile ; then
            echo
            echo -e "--- ${RED}FAILED !!!${NC} ---"
            echo
        else
            echo
            echo -e "--- ${GREEN}PASSED !!!${NC} ---"
            echo
        fi
    fi
}

run_java(){
    # Check and remove previous .class file

     if [[ -f "$name.class" ]]; then
         echo "Deleting existing $name.class ....."
         echo
         rm -rf ./$name.class
     fi

     # check if previous logfile is exist
     if [[ -f "$logfile" ]]; then
         echo "Deleting existing $logfile ....."
         echo
         rm -rf ./$logfile
     fi

    # Compile java file
    echo "--- COMPILING ---"
    javac $filename 2> $logfile

    # Checking error in the logfile
    if egrep -qE "error|undefined" $logfile ; then
         echo
         echo -e "*** ${RED}COMPILED ERROR !!!${NC} ***"
         cat $logfile | egrep "error|undefined"
         exit 1
    else
         if grep -q -i "warning" $logfile ; then
             echo
             echo -e "*** ${YELLOW}WARNING !!!${NC} ***: Have a look !!!!"
             cat $logfile | grep "warning"
         fi

         echo "--- RUNNING ---"
         echo
         java $name
         echo
         echo -e "--- ${GREEN}FINISHED !!!${NC} ---"
         echo
    fi
}

#######################################################
#                    MAIN HERE
#######################################################

if [[ $filename == *.sh ]]; then       # Check if target file is a shell script
    run_shell "$@"
elif [[ $filename == *.py ]]; then     # Check if target file is python extension
    run_py "$@"
elif [[ $filename == *.ipynb ]]; then  # Check if target file is from Python Jupyter Notebook
    run_py "$@"
elif [[ $filename == *.c ]]; then      # Check if target file is c extension
    run_ccpp "$@"
elif [[ $filename == *.cpp ]]; then    # Check if target file is cpp extension
    run_ccpp "$@"
elif [[ $filename == *.java ]]; then   # Check if target file is java extension
    run_java "$@"
else
    echo "file extension is invalid"
fi
