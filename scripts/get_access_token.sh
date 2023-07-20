#!/bin/bash
#
#  Credits to noah (https://medium.com/@nschairer)
#  Who published this solution in this article: 
#      - https://medium.com/@nschairer/automating-google-drive-uploads-with-google-drive-api-curl-196989ffb6ce
#


set -euo pipefail

SCRIPTS_DIR=${SCRIPTS_DIR:-"/scripts"}
CONFIG_DIR=${CONFIG_DIR:-"/config"}

key_json_file="$1"
scope="$2"

jwt_token=$(bash $SCRIPTS_DIR/create_jwt_token.sh "$CONFIG_DIR/$key_json_file" "$scope")

access_token=$(curl -s -X POST https://oauth2.googleapis.com/token \
    --data-urlencode 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' \
    --data-urlencode "assertion=$jwt_token" \
    | jq -r .access_token)

echo $access_token
#####Use token for google drive -- this request should list files
#curl "https://www.googleapis.com/drive/v3/files?q='$PARENT_FOLDER_ID'+in+parents" \
#    -H "Authorization: Bearer $access_token"