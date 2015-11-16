#!/bin/bash

set -e

#######################################
# Global variables
#######################################
EXCLUDED_FILES="js,html"

#######################################
# Look for vulns of specific languages
# Globals:
#   EXCLUDED_FILES 
# Arguments:
#   Language (lowercase) Ex.: php, java
#   Path Ex.: .
# Returns:
#   None
#######################################

search_vulns() {
    excluded_files="*.{$EXCLUDED_FILES}"
    #echo $excluded_files
    case "$1" in
        # Java
        "java")
        echo "JAVA"
        ;;
        # PHP
        "php")
        echo "PHP"
        echo $excluded_files
        bash -c "grep -RE \"exec\(.*?\)|system\(.*?\)\" --color=auto --exclude=$excluded_files $2"
        ;;
    *)
        echo $"[! function] Usage: search_vulns [LANGUAGE] [DIRECTORY]"
        exit 1
    esac
}

search_vulns $1 $2
