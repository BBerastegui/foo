#!/bin/bash
set -e

tmpFilename=/tmp/$RANDOM'_dict.dict'

main() {
    # TODO parse_options $@
    echo "[i] Getting folders and file names... (May take a while)"
    find . -exec basename {} \; > $tmpFilename
    sort_and_unique
    remove_images
    cleanup
}

check_git_url(){
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    string=$1
    if [[ $string =~ $regex ]]
    then 
        echo "Link valid"
        git clone $1 
    else
        echo "Link not valid"
    fi
}

sort_and_unique() {
    echo "[i] Sorting and \"unique-ing...\""
    sort $tmpFilename -u -o $tmpFilename
}

remove_images() {
    echo "[i] Removing images... (bmp|gif|jpg|png)"
    sed -i.bak -E '/^.*\.(bmp|gif|jpg|png)$/d' $tmpFilename
}

remove_js_css() {
    echo "[i] Removing javascripts and css..."
    sed -i.bak -E '/^.*\.(css|js)$/d' $tmpFilename
}

remove_weird_extensions() {
    echo "[i] Removing weird extensions... (wav|mp3|...)"
    sed -i.bak -E '/^.*\.(wav|mp3)$/d' $tmpFilename
}

cleanup() {
    echo "[i] Cleaning up."
    finalFilename=${PWD##*/}_$(wc -l < $tmpFilename | awk '{print $1}')_dict.dict
    echo $finalFilename
    cp $tmpFilename $finalFilename
    rm $tmpFilename.*
}

# TODO
parse_options(){
    while :
    do
        case "$1" in
            -u | --url)
                check_git_url "$2"   # You may want to check validity of $2
                shift 2
                ;;
            -h | --help)
                display_help  # Call your function
                # no shifting needed here, we're done.
                exit 0
                ;;
            -u | --user)
                username="$2" # You may want to check validity of $2
                shift 2
                ;;
            -v | --verbose)
                #  It's better to assign a string, than a number like "verbose=1"
                #  because if you're debugging the script with "bash -x" code like this:
                #
                #    if [ "$verbose" ] ...
                #
                #  You will see:
                #
                #    if [ "verbose" ] ...
                #
                #  Instead of cryptic
                #
                #    if [ "1" ] ...
                #
                verbose="verbose"
                shift
                ;;
            --) # End of all options
                shift
                break
                ;;
            -*)
                echo "Error: Unknown option: $1" >&2
                exit 1
                ;;
            *)  # No more options
                break
                ;;
        esac
    done
}

main "$@"
