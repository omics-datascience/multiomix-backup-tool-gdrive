#!/bin/bash
#
#   This command will create a dump file of a postgres database and will save inside
#   a folder called like the db inside BACKUP_DIR environment variable.
#
#   Usage:
#       ./dump_postgres_db.sh <host> <database-name> <username-env-var-name> <password-env-var-name>
#       
#   Credentials will be taken from Environment variables name in the arguments.
#

if [ $# -lt 4 ]
then
    echo "Error: Missing arguments." 1>/dev/stderr
    echo -e "\nUsage:"
    echo -e "    $0 <host-env-var-name> <databaseenv-var-name> <user-env-var-name> <pass-env-var-name>\n"
    exit 1
fi

HOST=${!1}
DATABASE=${!2}
USERNAME=${!3}
PASSWORD=${!4}
START_DATE=$(date +%Y-%m-%d_%H-%M-%S_)
SCRIPTS_DIR=${SCRIPTS_DIR:-"/scripts"}
BACKUP_DIR=${BACKUP_DIR:-"/backup"}
OUTPUT_FILENAME=$DATABASE

mkdir -p $BACKUP_DIR/pg_dump/
echo "Trying dump of '$DATABASE' in '$HOST'..."
PGPASSWORD=$PASSWORD pg_dump --host=$HOST --dbname=$DATABASE --username=$USERNAME --data-only --no-owner | gzip > $BACKUP_DIR/pg_dump/$START_DATE$OUTPUT_FILENAME.sql.gz

echo "Starting upload..."
bash $SCRIPTS_DIR/upload_file.sh "$BACKUP_DIR/pg_dump/$START_DATE$OUTPUT_FILENAME.sql.gz"