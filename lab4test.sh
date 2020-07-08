#!/bin/sh

#Alan Lee, 215612898
#Goal is to find all *.rec files (Readable files)
#Prompt user to enter command
#The input paramater is the path in which all *.rec files are under including subdirectories

helper() {
    echo 'l or list: lists found course'
    echo 'ci: gives the name of all courses plus number of credits'
    echo 'sl: gives a unique list of all students registered in all courses'
    echo 'sc: gives the total number of unique students registered in all courses'
    echo 'cc: gives the total numbers of found course files.'
    echo 'h or help: prints the current message.'
    echo 'q or quit: exits from the script'
}

course_count() {
    courses=$(grep 'COURSE NAME: ' $file | cut -d ' ' -f3-6 | wc -l)
    echo "There are $courses course files"
}

student_count() {
    #all IDS into one file
    grep '^[0-9]*' -o $file > allID
    uniquestudents=$(grep '[0-9][0-9][0-9][0-9][0-9][0-9]' -o allID | sort | uniq | wc -l)
    echo "There are $uniquestudents registered students in all courses."

    #Removing tempfiles
    rm allID
}

student_list() {
    echo 'Here is the unique list of student numbers in all courses:'
    #all IDS into one file
    grep '^[0-9]*' -o $file > allID
    #output unique IDS
    grep '[0-9][0-9][0-9][0-9][0-9][0-9]' -o allID | sort | uniq

    #Removing tempfiles
    rm allID
}

course_info() {
    echo 'Found courses are:'
    for course in $file 
    do
        poo=$(grep 'COURSE NAME: ' $course | grep -i '[A-Z]* [A-Z]*$' -o | xargs printf '%s %s has ')
        shit=$(grep 'CREDITS: ' $course | grep '[0-9]*$' -o | xargs printf '%d')

        echo "$poo$shit credits"
        poo=""
        shit=""
    done
    
}

course_list() {
    echo 'Here is a list of found class files'
    find $1 -type f -readable -name '*.rec'
}

#Files that are readable *.rec files
file=$(find $1 -type f -readable -name '*.rec')


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

    #commands
    if test $usercommand = "q"
    then
        echo 'Goodbye'
        break
    elif test $usercommand = "list" || test $usercommand = "List" || test $usercommand = "l"
    then
        course_list

    elif test $usercommand = "ci"
    then
        course_info

    elif test $usercommand = "sl" 
    then
        student_list

    elif test $usercommand = "sc"
    then
        student_count
    
    elif test $usercommand = "cc" 
    then
        course_count

    elif test $usercommand = "h" || test $usercommand = "help"
    then
        helper

    else
        echo 'Unrecognized command!'
    fi
done

exit 0