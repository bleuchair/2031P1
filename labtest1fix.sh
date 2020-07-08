#!/bin/sh
#Alan Lee, 215612898

#Files that are readable *.rec files
file=$(find $1 -type f -readable -name '*.rec')

helper() {
    #Output all the help commands
    echo 'Here are defined commands:'
    echo 'creg: give the list of course names with the total number of students registered in each course.'
    echo 'stc ######: gives the name of all course names in which the student with ###### id registered in.'
    echo 'gpa ######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   . . . + course_n*credit_n) / (credit_1+ . . . + credit_n)'
    echo 'h: prints the current message.'

}

student_count() {
    #Goes through each course in the array of files in $file to find the coursename
    for course in $file
    do
        tr [:lower:] [:upper:] < $course > upcoursename 
        read dummy1 dummy2 dummy3 coursename < upcoursename
        number=$(grep '^[0-9]*' -o $course | wc -l)
        echo "In \"$coursename\", $number students register."
        number=0
        rm upcoursename
    done
    
}

student_info() {
    #Checks if student belongs at least 1 course before it goes through the loop
    numbercount=$(grep $1 -o $file | wc -l)
    if test $numbercount -gt 0 
    then
        echo "The student with id: $1, is registered in the following courses:"
        counter=1
        for course in $file
    do
        #Searching for coursename
        tr [:lower:] [:upper:] < $course > upcoursename 
        read dummy1 dummy2 dummy3 coursename < upcoursename
        number=$(grep $1 -o $course)
        rm upcoursename
        cat $course | tr -s ' ' > tempcheck
        thecredits=$(grep -i 'CREDITS' tempcheck | grep '[0-9]*$' -o | xargs printf '%d')
        rm tempcheck
        if test ! -z $number 
        then
            echo "$counter. $coursename which has $thecredits credits."
            thecredits=""
            counter=$(expr $counter + 1)
        else
            echo -n ""
        fi
    done
    else
        echo "The student id: $1 is not registered in any course."
    fi
    
}
if test $# -lt 1
then
    echo 'You should enter the path name for coures files and at least one command'
    exit 1
fi

if test $2 = 'h' 
then
    helper
elif test $2 = 'creg' 
then
    student_count
elif test $2 = 'stc'
then
    #Check if the third parameter is 6 digits long
    if test ${#3} -ne 6 
    then
        echo 'The student id should be 6 numbers.'
    else
        student_info $3
    fi
fi