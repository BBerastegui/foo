#!/bin/bash

set -e

#######################################
# Global variables
#######################################
# Excluded files
EXCLUDED_FILES="css,html,js"

# Regex sets for languages
REGEX[php]="exec\(.*?\)|system\(.*?\)"
REGEX[java]="Runtime.getRuntime\(.*?\)"
REGEX[generic]="password|pass"

#######################################
# Look for vulns of specific languages
# Globals:
#   EXCLUDED_FILES 
# Arguments:
#   $1 - Language (lowercase) Ex.: php, java
#   $2 - Path Ex.: .
# Returns:
#   None
#######################################

search_vulns() {
    excluded_files="*.{$EXCLUDED_FILES}"
    echo $excluded_files
    for i in "${REGEX[java]}"
    do
        echo $i
    done
    #bash -c "grep -RE \"$REGEX[$1]\" --color=auto --exclude=$excluded_files $2"
}

search_vulns $1 $2
