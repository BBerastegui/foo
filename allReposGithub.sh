#!/bin/bash

set -e

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36"
OUTPUT_FOLDER="."

create_tmp_folder(){
    mkdir /tmp/$TMP_FILENAME
    OUTPUT_FOLDER=/tmp/$TMP_FILENAME
}

clone_repo() {
    local repo=$1
    echo "[i] Cloning https://github.com/$github_username/$repo.git ."
    git clone https://github.com/$github_username/$repo.git $OUTPUT_FOLDER/$repo
}

get_repo_list(){
    curl -A "$USER_AGENT" https://api.github.com/users/$github_username/repos -o /tmp/$TMP_FILENAME.repositories.json
    sed -n 's/.*"name": "\(.*\)",/\1/p' /tmp/$TMP_FILENAME.repositories.json |
    while IFS= read -r line
    do
        clone_repo $line
    done
}

main(){
#
if [ $# -eq 0 ]
  then
    echo "No arguments supplied."
    echo -n "[i] Enter user name: " 
    read github_username
    TMP_FILENAME=$github_username.$$
    create_tmp_folder
fi
#
if [ $# -eq 1 ]
  then
    echo "Only username supplied."
    github_username=$1
    TMP_FILENAME=$github_username.$$
    create_tmp_folder
fi
#
if [ $# -eq 2 ]
  then
    echo "Username and folder supplied."
    github_username=$1
    OUTPUT_FOLDER=$2
fi
TMP_FILENAME=$github_username.$$
get_repo_list
}

main $@
