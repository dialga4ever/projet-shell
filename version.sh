#!/bin/dash

remove_version(){


    read -p "Are you sure you want to delete ’example.txt’ from versioning ? (yes/no) " rep
    if [ "$rep" = "no" ]
    then
        echo "Nothing done."
    else
        echo "$2 is not under versioning anymore."
    fi
}
if [ "$1" = "--help" ] 
then
    if [ $# -eq 1 ]
    then
        echo "Usage:"
        echo "     ./version.sh --help"
        echo "     ./version.sh <command> FILE [OPTION]"
        echo "     where <command> can be: add amend checkout|co commit|ci diff log reset rm"
        echo ""
        echo "./version.sh add FILE MESSAGE"
        echo "     Add FILE under versioning with the initial log message MESSAGE"
        echo ""
        echo "./version.sh commit|ci FILE MESSAGE"
        echo "     Commit a new version of FILE with the log message MESSAGE"
        echo ""
        echo "./version.sh amend FILE MESSAGE"
        echo "     Modify the last registered version of FILE, or (inclusive) its log message"
        echo ""
        echo "./version.sh checkout|co FILE [NUMBER]"
        echo "     Restore FILE in the version NUMBER indicated, or in the"
        echo "     latest version if there is no number passed in argument"
        echo ""
        echo "./version.sh diff FILE"
        echo "     Displays the difference between FILE and the last committed version"
        echo ""
        echo "./version.sh log FILE"
        echo "     Displays the logs of the versions already committed"
        echo ""
        echo "./version.sh reset FILE NUMBER"
        echo "     Restores FILE in the version NUMBER indicated and"
        echo "     deletes the versions of number strictly superior to NUMBER"
        echo ""
        echo "./version.sh rm FILE"
        echo "     Deletes all versions of a file under versioning"
        exit 0
    else
        echo "Error : "2>&1 #mauvaise utilisation de --help
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
else 
    if [ $# -eq 3 ] || [ $# -eq 2 ]
    then
        if ! [ -f "$2" ]
        then
            echo "Error : second argument isn't a regular file" 2>&1
            echo 'Enter "./version.sh --help" for more information.' 2>&1
            exit 1
        fi


        if [ "$1" = "add" ]; then
            echo "i"
        elif [ "$1" = "rm" ]; then
            echo "1"
            remove_version  $2
        else

            echo "Error : "
        fi
    fi
fi


create_versionSH() {
    dirname $2 | cd 
    mkdir .version 2>/dev/null
}



