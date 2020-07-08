#!/bin/sh

#Alan Lee, 215612898
#Goal is to find all *.rec files (Readable files)
#Prompt user to enter command (List all readable files found "list", Quit "q")
#The input paramater is the path in which all *.rec files are under including subdirectories
leave="q"
listing="list"
listingC="List"

#Check the number of arguments
if test $# -ne 1 
then
    echo 'There can only be one argument'
    exit 1
fi

#Assign variable to contain the value of the number of *.rec files
countrec=$(find $1 -type f -readable -name '*.rec' | wc -l)

#Checking if there's any *.rec files that are readable , if there aren't any exit
if test $countrec -eq 0
then
    echo 'There is not any readable *.rec file exists in the specified path or its subdirectories'
    exit 1 
    
fi

#Continually prompts user for commands until "q"
#Contains command q , list otherwise unrecognizable command
while true 
do
    printf "command: "
    read usercommand

    if test $usercommand = $leave
    then
        break 
    elif test $usercommand = $listing || test $usercommand = $listingC
    then
        echo 'Here is a list of found class files'
        find $1 -type f -readable -name '*.rec'
    else
        echo 'Unrecognized command!'
    fi

done

exit 0