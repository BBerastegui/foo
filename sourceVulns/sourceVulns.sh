#!/bin/bash

set -u

#######################################
# Load the dependencies
#######################################
source ./search.sh

#######################################
# Main function
#######################################
main() {
    add_internal_information
    add_vulns $LANGS
    run_code_search $@
}

#######################################
# Go, go, go !
#######################################

main $@
