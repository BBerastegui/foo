#!/bin/bash

while [[ $# > 0 ]]
do
key="$1"
case $key in
    -u|--url)
        TARGETURL="$2"
        shift # pass argument
    ;;
    *)
        exit # unknown option
    ;;
esac
shift # pass argument or value
done

echo -e "\n[i] Response headers:\n"
curl -s -D - $TARGETURL -o /dev/null

echo -e "[i] HTTP methods check\n"
methods=("GET" "HEAD" "POST" "PUT" "DELETE" "CONNECT" "OPTIONS" "TRACE" "TRACK" "NONEXISTENT")
for m in "${methods[@]}"
do
    statusCode=$(curl -m 3 -s -o /dev/null -w "%{http_code}" -X $m $TARGETURL)
    if [ $statusCode = "405" ]; then
        echo -e "\t[i] $m not allowed."
    else
        echo -e "\t[!] $m returned $statusCode."
    fi
done
echo 
