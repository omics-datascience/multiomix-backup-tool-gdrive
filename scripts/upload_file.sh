#!/bin/bash
#
#   This script will upload a file into a Google Drive folder with 
#   the id that is in environment variable PARENT_FOLDER_ID
#

if [ $# -lt 1 ]
then
    echo "Error: Missing arguments." 1>/dev/stderr
    echo -e "\nUsage:"
    echo -e "    $0 <file-to-upload>\n"
    exit 1
fi

SCRIPTS_DIR=${SCRIPTS_DIR:-"/scripts"}
CONFIG_DIR=${CONFIG_DIR:-"/config"}
PARENT_FOLDER_ID=${PARENT_FOLDER_ID}
GOOGLE_CRED_FILENAME=${GOOGLE_CRED_FILENAME:-"google-key.json"}
ACCESS_TOKEN=$(bash $SCRIPTS_DIR/get_access_token.sh $GOOGLE_CRED_FILENAME "https://www.googleapis.com/auth/drive.file")


## Code taken from https://labbots.com/google-drive-upload-bash-script/
## A better approach is in there. This script only takes the basic.

    FILE="$1"
    MIME_TYPE=$(file --brief --mime-type "$FILE")
    SLUG=$(basename "$FILE")
    FILESIZE=$(stat -c%s "$FILE")

    # JSON post data to specify the file name and folder under while the file to be created
    postData="{\"mimeType\": \"$MIME_TYPE\",\"title\": \"$SLUG\",\"parents\": [{\"id\": \"$PARENT_FOLDER_ID\"}]}"
    postDataSize=$(echo $postData | wc -c)

	# Curl command to initiate resumable upload session and grab the location URL
	echo "Generating upload link for file $FILE ..."

    uploadlink=$(curl \
				--silent \
				-X POST \
				-H "Host: www.googleapis.com" \
				-H "Authorization: Bearer ${ACCESS_TOKEN}" \
				-H "Content-Type: application/json; charset=UTF-8" \
				-H "X-Upload-Content-Type: $MIME_TYPE" \
				-H "X-Upload-Content-Length: $FILESIZE" \
				-d "$postData" \
				"https://www.googleapis.com/upload/drive/v2/files?uploadType=resumable" \
				--dump-header - | sed -ne s/"location: "//p | tr -d '\r\n')

	# Curl command to push the file to google drive.
	# If the file size is large then the content can be split to chunks and uploaded.
	# In that case content range needs to be specified.
	echo "Uploading file $FILE to google drive in '$uploadlink'..."
	curl \
	-X PUT \
	-H "Authorization: Bearer ${ACCESS_TOKEN}" \
	-H "Content-Type: $MIME_TYPE" \
	-H "Content-Length: $FILESIZE" \
	-H "Slug: $SLUG" \
	-T "$FILE" \
	--output /dev/null \
	"$uploadlink"

## Code taken from https://labbots.com/google-drive-upload-bash-script/
## A better approach is in there. This script only takes the basic and doesn't
## support resuming yet.





