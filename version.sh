#!/bin/dash

log(){
    if [ -f $DIR/.version/$NAME.latest ]
    then
        nl -ba -s" : " $DIR/.version/$NAME.log
    else
        echo "Error : $NAME is not under versioning" 2>&1
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
}



normelize(){
    echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

supr(){
    read -p "Are you sure you want to delete ’$NAME’ from versioning ? (yes/no) " rep
    if [ "$rep" = "no" ]
    then
        echo "Nothing done."
    else
        rm $DIR/.version/$NAME.*
        #verifier si .version est vide
        if [ -d $DIR/.version ]
        then
            rmdir $DIR/.version 2>/dev/null
        fi
        echo "$1 is not under versioning anymore."
    fi
}
#oui
#create a folder .version fi not create in the directory of the file and create a folder with the name of $1 with inital log message
add() {
    if [ -f $DIR/.version/$NAME.1 ]
    then
        echo "Error : $NAME is already under versioning" 2>&1
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
    mkdir -p $DIR/.version/
    msg=$(normelize "$1")
    echo "$date '$msg'" > $DIR/.version/$NAME.log
    cp $1 $DIR/.version/$NAME.latest
    cp $1 $DIR/.version/$NAME.1
}
#get the highest number of .version/$1/ number.log
lastlog(){
    ls $DIR/.version/$NAME.* | grep -Eo '[0-9]+' | sort -n | tail -1
}
differ(){
    diff -u $DIR/.version/$NAME.latest $1
}
commit(){
    if [ -f $DIR/.version/$NAME.latest ]
    then
        #compare $1 with last file
        if cmp $DIR/$NAME $DIR/.version/$NAME.latest 2>/dev/null
        then
            echo "Error : $NAME has been not modified since the last commit" 2>&1
            exit 1
        fi
        lastlog=$(lastlog)
        newlog=$(($lastlog+1))

        diff -u $NAME $DIR/.version/$NAME.latest  > $DIR/.version/$NAME.$newlog
        cp $NAME $DIR/.version/$NAME.latest
        date=$(date -R)
        msg=$(normelize "$1")
        echo "$date '$msg'" >> $DIR/.version/$NAME.log
        echo "Committed a new version: $newlog"
    else
        echo "Error : $NAME is not under versioning" 2>&1
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
}
#show diff beetween last commited version and the $NAME
show_diff(){
    if [ -f $DIR/.version/$NAME.latest ]
    then
        diff -u $DIR/.version/$NAME.latest $DIR/$NAME
        
    else
        echo "Error : $NAME is not under versioning" 2>&1
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
}


# patch $1 to the version $2
checkout(){ 
    if [ -f $DIR/.version/$NAME.1 ]
    then
        if [ $# -eq 2    ]
        then
            if [ -f $DIR/.version/$NAME.$2 ]
            then
                cp $DIR/.version/$NAME.1 $1


                i=2
                while [ $i -le $2 ]
                do
                    patch -Ru $NAME $DIR/.version/$NAME.$i 1>/dev/null
                    i=$(($i+1))
                done


                echo "Checked out version: $2"
            else
                echo "Error : $2 is not a valid version number" 2>&1
                echo 'Enter "./version.sh --help" for more information.' 2>&1
                exit 1
            fi
        else
            diff -u $NAME $DIR/.version/$NAME.latest  > $DIR/.version/$NAME.latest.diff
            patch -u $NAME $DIR/.version/$NAME.latest.diff
            echo "Checked out to the latest version"
        fi
    else
        echo "Error : $NAME is not under versioning" 2>&1
        echo 'Enter "./version.sh --help" for more information.' 2>&1
        exit 1
    fi
}
if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ $# -eq 0 ]
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


        DIR=$(dirname $2)
        NAME=$(basename $2)

        if [ "$1" = "add" ]; then
            add $3
        elif [ "$1" = "rm" ]; then
            supr  $2
        elif [ "$1" = "commit" ] || [ "$1" = "ci" ]; then
            commit "$3"
        elif [ "$1" = "diff" ]; then
            differ $2
        elif [ "$1" = "checkout" ] || [ "$1" = "co" ]; then
            checkout $2 $3
        elif [ "$1" = "diff" ]; then
            show_diff $2
        elif [ "$1" = "log" ]; then
            log $2
        else
            echo "Error : "
        fi
    fi
fi




