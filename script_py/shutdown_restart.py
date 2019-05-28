#!/usr/bin/env python3

#####################################################
# File name     : shutdown_restart.py
# Author        : Brian Truong
# Description   : Shutdown and restart computer
# Date          : April 13, 2019
# Version       : 1.0 - First Created
#
# Future plan   : Check if program still opened
#                   before restarting or turning off
######################################################


import os

print("1. Shutdown Computer")
print("2. Restart Computer")
print("3. Exit")

valid = True
invalid_prompt = ("\nInvalid choice!!! Please enter correct one!!!")

while valid:
    choice = input("\nEnter your choice: ")
    if not choice.isdigit():
        print(invalid_prompt)
    elif int(choice) == 1:
        os.system("sudo shutdown -P now")
    elif int(choice) == 2:
        os.system("sudo shutdown -r")
    elif int(choice) == 3:
        exit()
    else:
        print(invalid_prompt)

