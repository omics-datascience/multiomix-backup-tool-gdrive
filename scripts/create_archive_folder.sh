#!/bin/bash
#
#   This command will create an compressed archive from a parent folder and will save it
#   inside the folder defined in BACKUP_DIR environment variable.
#
#   Usage:
#   ./create_archive_folder.sh <parent-folder-to-archive> [output-filename]
#
#   If no output file arg is defined, it will use date (+%Y-%m-%d_%H-%M-%S) plus parent folder 
#   name without spaces.
#   
#       2023-07-19_20-03-40_parent-folder.tar.gz
#


if [ $# -lt 1 ]
then
    echo "Error: Missing arguments." 1>/dev/stderr
    echo -e "\nUsage:"
    echo -e "    $0 <parent-folder-to-archive> [output-filename]\n"
    exit 1
fi


START_DATE=$(date +%Y-%m-%d_%H-%M-%S)
PARENT_FOLDER=$1
DEFAULT_OUTPUT=$START_DATE"_$(echo $PARENT_FOLDER | sed -r 's/\s+/_/g' | sed -r 's/\//-/g').tar.gz"
BACKUP_DIR=${BACKUP_DIR:-"/backup"}
SCRIPTS_DIR=${SCRIPTS_DIR:-"/scripts"}

OUTPUT_FILENAME=${2:-$DEFAULT_OUTPUT}

mkdir -p $BACKUP_DIR/archives/

echo "Creating archive of parent folder '$PARENT_FOLDER' in '$BACKUP_DIR/$OUTPUT_FILENAME'..."

tar -cvf $BACKUP_DIR/archives/$OUTPUT_FILENAME $PARENT_FOLDER

bash $SCRIPTS_DIR/upload_file.sh "$BACKUP_DIR/archives/$OUTPUT_FILENAME"