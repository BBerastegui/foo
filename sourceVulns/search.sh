#!/bin/bash
set -u

#######################################
# Global variables
#######################################
source ./sourceconfig.conf

#######################################
# Run the regex search
# Globals:
#   EXCLUDED_FILES
#   FINAL_REGEX
# Arguments:
#   $1 - Path Ex.: .
# Returns:
#   None
#######################################

run_code_search(){
    echo "Excluded files: $EXCLUDED_FILES"
    local excluded_files="*.{$EXCLUDED_FILES}"

    read -p "Are you sure you want to run: \"egrep -I --color=auto --exclude=$excluded_files -R $FINAL_REGEX $1\" " -n 1 -r
    echo # Move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    else
        echo $excluded_files
        egrep -I --color=auto --exclude=$excluded_files -R $FINAL_REGEX $1
    fi
}

#######################################
# Load the regex for internal information search
# Globals:
#   INTERNAL_INFO
# Arguments:
#   None
# Returns:
#   None
#######################################

add_internal_information() {
    while read -r line; do
        echo "[i] Adding \"$line\" to the set of regex."
        FINAL_REGEX+="-e $line "
    done <<< "$INTERNAL_INFO"
}

#######################################
# Load the regex for code vulnerability
# Globals:
#   CODE_VULNS
# Arguments:
#   $1 - Languages to check. It could be comma separated values (JAVA,ASP,PERL)
# Returns:
#   None
#######################################

add_vulns() {
    for lang in $(echo $1 | sed "s/,/ /g")
    do
        VULNS_LANG_TMP="VULNS_$lang"
        VULNS_LANG=${!VULNS_LANG_TMP}
        while read -r line; do
            echo "[i] Adding \"$line\" to the set of regex."
            FINAL_REGEX+="-e $line "
        done <<< "$VULNS_LANG"
    done
}
