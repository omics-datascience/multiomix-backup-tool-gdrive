#!/bin/bash
#
#  Credits to noah (https://medium.com/@nschairer)
#  Who published this solution in this article: 
#      - https://medium.com/@nschairer/automating-google-drive-uploads-with-google-drive-api-curl-196989ffb6ce
#


set -euo pipefail

base64var() {
    printf "$1" | base64stream
}

base64stream() {
    base64
}

key_json_file="$1"
scope="$2"
valid_for_sec="${3:-3600}"
private_key=$(jq -r .private_key $key_json_file)
sa_email=$(jq -r .client_email $key_json_file)

header='{"alg":"RS256","typ":"JWT"}'
claim=$(cat <<EOF | jq -c .
  {
    "iss": "$sa_email",
    "scope": "https://www.googleapis.com/auth/drive",
    "aud": "https://oauth2.googleapis.com/token",
    "exp": $(($(date +%s) + $valid_for_sec)),
    "iat": $(date +%s)
  }
EOF
)
request_body="$(base64var "$header").$(base64var "$claim")"
signature=$(openssl dgst -sha256 -sign <(echo "$private_key") <(printf "$request_body") | base64stream)

printf "$request_body.$signature"
