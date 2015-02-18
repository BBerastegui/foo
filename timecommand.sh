#!/bin/bash
set -o errexit
set -o nounset

# Start and end time
START=$(date -d "Feb 18 2015 21:00:00" +%s)
END=$(date -d "Feb 19 2015 05:20:00" +%s)
# Current time
HOUR=$(date +%s)
# Deadman: Set a resource under your control.
# If that resource is created, the next time is checked, the program will exit.
DEADMAN="http://XXX.XXX/kill.now"
# Log folder

log(){
    echo $1
    echo $(date "+%b %d %H:%M:%S ")$1 >> $(date "+%b%d%H00").log 
}

# Start check
while [ $HOUR -lt $START ]; do
    log "[i] Not yet..."
    log "[i] The hour is $HOUR and the start time is $START ..."
    sleep 30
    HOUR=$(date +%s)
done

run(){
    # DO WHILE TIME OK
    while [ $HOUR -lt $END ]; do
        ##### SET YOUR COMMAND HERE #####
        


        ##### /SET YOUR COMMAND HERE #####
        HOUR=$(date +%s)
    done
    kill 0
    exit 0
}

deadman(){
    echo "[i] Deadman running..."
    for (( ; ; ))
    do
        sleep 30
        log "[i] Checking for deadman... $DEADMAN"
        if [ $(curl -sL -w "%{http_code}\\n" $DEADMAN -o /dev/null) -eq 200 ]; then
            log "[/!\\] Triggering exit."
            kill 0
            exit 0
        fi
    done
}

deadman &
run
