#!/bin/bash
set -e

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "[i] Getting ip address from: $line"
    dig +short $line >> $1_ip.list
done < "$1"

sort -u $1 -o $1
