#!/bin/bash
set -e

restoreServices(){
    echo "[i] Restoring services..."
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.Kerberos.kdc.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
    #    sudo launchctl load /System/Library/LaunchDaemons/com.apple.smbd.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.netbiosd.plist
}

stopServices () {
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.Kerberos.kdc.plist
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
    #    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.smbd.plist
    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.netbiosd.plist
}

confirm () {
    # Credit: http://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

runResponder () {
    trap restoreServices EXIT
    stopServices
    sudo python Responder.py "$@"
}

if [ $# -ne 0 ]; then
    confirm "[!] Stop services and run Responder.py?" && runResponder
    exit
else
    echo "[!] Set some parameters."
    exit
fi
