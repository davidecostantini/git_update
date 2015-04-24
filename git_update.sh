#!/bin/sh
print_msg() {
  case $1 in
      "red" )
          msg="\e[1;31m $2" ;;
      "green" )
          msg="\e[1;32m $2" ;;
      "cyan" )
          msg="\e[1;36m $2" ;;
      *) 
          msg="\e[1;37m $2" ;;          
  esac  
  echo -e "$msg \e[0m"
}

branch_name=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ "$branch_name" == "" ]; then
	print_msg "red" "Sorry mate! I wasn't able to identify the branch! :-("
	exit 1
fi

echo "Do you wish to push on branch $branch_name (y/n)?"
read answ
if [ "$answ" != "y" ]; then
	print_msg "red" "Exiting"
	exit
fi

print_msg "cyan" "Branch detected: $branch_name"

if [ -z "$1" ]; then
	print_msg "red" "Comment not specified, used default"
	DESC="Minor changes to files not commented"
else
	DESC=$1
	print_msg "green" "Comment: $DESC"
fi

#Removing .pyc files (if not Python project shouldn't affect the code)
print_msg "cyan" "Removing .pyc files"
rm -rf *.pyc

for D in ./*; do
    if [ -d "${D}" ]; then
        print_msg "cyan" "Adding ${D} folder"
        git add $D
    fi
done

print_msg "cyan" "Adding files"
git add .

print_msg "cyan" "Committing..."
git commit -m "$DESC"

print_msg "cyan" "Pushing..."
git push origin $branch_name

print_msg "green" "DONE! ;-)"
