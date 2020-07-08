#!/bin/sh

#######
# The purpose of the lab are to learn:
# In Lab 3, we have learnt:
# * implementing loops
# * reading from standard input
# * checking input parameters
# * checking condition
# In Lab 4, we will learn:
# * function definition and calling
# * nested loops
# * reading from files
# * doing simple calculation
# * use advance feature of shell script programming
#######


# Finds course information from course files
course_info()
{
  # The $course_files variable contains list of all courses.
  for course in $course_files
  do
     # read can read from files. d1 and d2 are summy variables which contain
     # "COURSE and "NAME:" entries. The $course_name variable gets the course name entry 
     read d1 d2 course_name < $course
     
     # To find credit, first, we need to find the credit line and then look for the credit number 
     credits=`grep "CREDITS:[[:space:]]* [0-9]" $course | grep -o [0-9]` 
     echo $course_name has $credits credits.
  done
}

# Makes a unique student list from all course files
student_list()
{
  tmp_file=/tmp/__tmp
  for course in $course_files
  do
     # +3 ignores the first two files, cut gets the first field 
     # and stores it into a temporary file. 
     
     #First way
     #tail -n +3 $course | cut -f1 -d" "  >> $tmp_file
     #Second way
     grep -o "[0-9]\{6\}" $course >> $tmp_file
  done
  # apply sort and uniq on the content of the temporary file
  sort $tmp_file | uniq
  # remove the temporary file
  rm $tmp_file
}

# The help method
help()
{
  echo 'Here are defined commands: '
  echo 'l or list: lists found courses'
  echo 'ci: gives the name of all courses plus number of credits'
  echo 'sl: gives a unique list of all students registered in all courses'
  echo 'sc: gives the total number of unique students registered in all courses'
  echo 'cc: gives the total numbers of found course files.'
  echo 'h or help: prints the current message.'
  echo 'q or quit: exits from the script'
}

if [ $# -eq 0 ] 
then
  echo 'You should enter the path name for course files'
  echo Use: lab3.sh path 
  echo 'Example: lab3.sh ~'
  exit 1
fi

path=$1

# find files with read permission in the defined path
course_files=`find $path -type f -name '*.rec' -perm /444`

# check if we find at least one file
if [ "X${course_files}" = "X" ]
then
  echo 'There is not readable *.rec file exists in the specified path or its subdirectories'
  exit 1
fi

# main loop
#clear
prompt="command: "
printf "$prompt"

while true
do
  read command 
  case $command in
    l | list) echo 'Here is the list of found course files:' 
              echo $course_files;;
    ci) echo 'Found courses are:'
        course_info;;
    sl) echo 'Here is the unique list of student numbers in all courses:'
        student_list;;
    sc) echo 'There are' `student_list | wc -l` 'registered students in all courses.';; 
    cc) echo 'There are' `echo -n $course_files | wc -w` course files.;;
    h | help) help;;
    q | quit) echo goodbye
              break;;
    *) echo 'Unrecognized command!';;
  esac
  
  printf "$prompt"         
done


exit 0
