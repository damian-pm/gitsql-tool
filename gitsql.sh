#!/bin/bash

####################################################
# DATABASE CONFIGURATION
USER_LOGIN="damian"
USER_PASS="damian"
PORT=3306
HOST=localhost
#####################################################
DIR_PATH="`dirname \"$0\"`"

type=$1

if [ "export" == "$type"  ]
then
    DB_NAME=$2
    DB_SUB_NAME=$3
    DB_TEMP_NAME=''
    echo '* Export from database to file *'
    echo '********************************'

    if [ -z "$DB_NAME" ]
    then 
        echo 'Fail command'  
        exit
    fi

    if [ -z "$DB_SUB_NAME" ]
    then 
        DB_TEMP_NAME=$DB_NAME
    else
        DB_TEMP_NAME=$DB_SUB_NAME
    fi

    echo 'exporting, please wait ...'
    mysqldump -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS  $DB_NAME > $DIR_PATH"/"$DB_TEMP_NAME".sql"
    echo '* Export success *'

elif [ "import" == "$type"  ]
then
    DB_SUB_NAME=$2
    DB_NAME=$3
    DB_TEMP_NAME=''
    echo '* Import from file to database *'
    echo '********************************'

    if [ -z "$DB_SUB_NAME" ]
    then 
        echo 'Fail command' 
        exit
    fi

    if [ -z "$DB_NAME" ]
    then 
        DB_NAME=$DB_SUB_NAME
    fi

    echo 'importing, please wait ...'
    mysql -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS  $DB_NAME < $DIR_PATH"/"$DB_SUB_NAME".sql"
    echo '* Import success *'
elif [ "list" == "$type"  ]
then
    TYPE_LIST=$2
    if [ "db" == "$TYPE_LIST" ]
    then
        echo '* Available databases        *'
        echo '******************************'
        mysql -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS $DB_NAME --execute="show databases;"
    else
        echo '* Available backup databases *'
        echo '******************************'
        ls -Ss1pqh db/
    fi

elif [ "rm" == "$type"  ]
then
    DB_NAME=$2
    echo '* Removing backup            *'
    echo '******************************'
    if [ -z "$DB_NAME" ]
    then 
        echo 'Failed remove backup, write please available backup name from "gitsql list"' 
        exit
    fi
    rm -rf "db/"$DB_NAME".sql"
    echo '* Backup '$DB_NAME" removed"
else 
    echo '*************************'
    echo '* GitSQL 1.0            *'
    echo '*************************'
    echo '* Methods:'
    echo '*'
    echo '* gitsql list [get list of backups]'
    echo '* gitsql list db [get list of databases]'
    echo '* gitsql import db_sub_name [if db_name not specifed, db_sub_name will be db_name ] db_name [optional] '
    echo '* gitsql export db_name db_sub_name [optional] '
    echo '*************************'
fi
