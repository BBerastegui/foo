#!/bin/bash

set -e

clone_repo() {
    echo "[i] Cloning https://github.com$1.git ."
    cd /tmp/$TMP_FILENAME
    git clone https://github.com$1.git
}

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36"

echo -n "[i] Enter user name: " 
read github_username

REGEXP_GITHUB='<a href="/'$github_username'/.*?">(.*?)<\/a>'
TMP_FILENAME=$github_username.$$

mkdir /tmp/$TMP_FILENAME

curl -A "$USER_AGENT" https://github.com/$github_username?tab=repositories -o /tmp/$TMP_FILENAME.repositories.html

cat /tmp/$TMP_FILENAME.repositories.html | tr -d '\n'| grep -oE "$REGEXP_GITHUB" | cut -d'"' -f2 |
while IFS= read -r line
do
    clone_repo "$line"
done

echo "[i] A folder /tmp/$TMP_FILENAME was created with all the cloned respositories."

