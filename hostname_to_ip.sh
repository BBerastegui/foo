#!/bin/bash
set -e

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "[i] Getting ip address from: $line"
    tmpIP=$(dig +short $line)
    if [ -z "$tmpIP" ]; then
        echo "    [!] Failed to resolve: $line"
    else
        echo $tmpIP >> $1_ip.list
    fi
done < "$1"

sort -u $1 -o $1
