#!/bin/bash

####################################################
# DATABASE CONFIGURATION
USER_LOGIN="damian"
USER_PASS="damian"
PORT=3306
HOST=localhost

# for Linux
PATH_MYSQL="mysql" 
PATH_MYSQL_DUMP="mysqldump"

# for Windows
# PATH_MYSQL="mysql.exe" 
# PATH_MYSQL_DUMP="mysqldump.exe"
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
    $PATH_MYSQL_DUMP -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS  $DB_NAME > $DIR_PATH"/db/"$DB_TEMP_NAME".sql"
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
    $PATH_MYSQL -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS  $DB_NAME < $DIR_PATH"/db/"$DB_SUB_NAME".sql"
    echo '* Import success *'
elif [ "list" == "$type"  ]
then
    TYPE_LIST=$2
    if [ "db" == "$TYPE_LIST" ]
    then
        echo '* Available databases        *'
        echo '******************************'
        $PATH_MYSQL -u $USER_LOGIN --port=$PORT --host=$HOST --password=$USER_PASS $DB_NAME --execute="show databases;"
    elif [ "zip" == "$TYPE_LIST" ]
    then
        echo '* Available backup databases zip*'
        echo '******************************'
        ls -Ss1pqh $DIR_PATH"/db_zip"
    else
        echo '* Available backup databases *'
        echo '******************************'
        # ls -Ss1pqh $DIR_PATH"/db"
        ls -lpqh $DIR_PATH"/db" | awk '{print $5, $6, $7, $8, $9}'
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
    rm -rf $DIR_PATH"/db/"$DB_NAME".sql"
    echo '* Backup '$DB_NAME" removed"
elif [ "rmzip" == "$type"  ]
then
    DB_NAME=$2
    echo '* Removing backup zip        *'
    echo '******************************'
    if [ -z "$DB_NAME" ]
    then 
        echo 'Failed remove backup zip, write please available backup name from "gitsql list zip"' 
        exit
    fi
    rm -rf $DIR_PATH"/db_zip/"$DB_NAME".zip"
    echo '* Backup zip '$DB_NAME" removed"

elif [ "zip" == "$type"  ]
then
    DB_SUB_NAME=$2
    echo '******************************'
    if [ -z "$DB_SUB_NAME" ]
    then 
        echo 'Failed zip backup, write please available backup name from "gitsql list"' 
        exit
    fi
    zip -j $DIR_PATH"/db_zip/"$DB_SUB_NAME".zip" $DIR_PATH"/db/"$DB_SUB_NAME".sql"
    echo 'File zip success - PATH:'$DIR_PATH"/db_zip/"$DB_SUB_NAME".zip"
elif [ "unzip" == "$type"  ]
then
    DB_SUB_NAME=$2
    echo '******************************'
    if [ -z "$DB_SUB_NAME" ]
    then 
        echo 'Failed zip backup, write please available backup name from "gitsql list"' 
        exit
    fi
    echo $DIR_PATH"/db"
    unzip $DIR_PATH"/db_zip/"$DB_SUB_NAME".zip"  -d  $DIR_PATH"/db"
    echo 'File unzip success - PATH:'$DIR_PATH"/db/"
else 
    echo '************************************'
    echo '* GitSQL Tool v1.0.2 (MySQL)        *'
    echo '************************************'
    echo '* Methods:'
    echo '*'
    echo '* gitsql list [get list of backups]'
    echo '* gitsql list db [get list of databases]'
    echo '* gitsql list zip [get list of db compresed zip]'
    echo '*'
    echo '* gitsql rm ps-1 [remove backup by name in db/]'
    echo '* gitsql rmzip ps-1 [remove backup bzip y name in db_zip/]'
    echo '*'
    echo '* gitsql import db_sub_name [if db_name not specifed, db_sub_name will be db_name ] db_name [optional] '
    echo '* gitsql export db_name db_sub_name [optional] '
    echo '*'
    echo '* gitsql zip db_name [zip file to db_zip/ if exists will replace]'
    echo '* gitsql unzip db_name [unzip file to db/ if exist will replace] '
    echo '*************************'
fi
