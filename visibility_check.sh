#!/bin/bash
set -e
set -u

function initial_setup(){
    VIS_DATE=$(date +"%Y%m%d_%H%M%S")
    mkdir $VIS_DATE"_files"
    cd $VIS_DATE"_files"
}

function set_ip_dst(){
    read -p "Set the destination IP address or range: " IP_DST
}

function set_ip_src(){
    read -p "Set the source IP address or range: " IP_SRC
    read -p "Set the capture interface: " CAP_INTERFACE
}

# TCP
function tcp_checks(){
    read -p "Perform \"weird\" scans (TCP Null, FIN, Xmas...)? " -n 1 -r
    echo
    nmap -r -sT $IP_DST -p- -oA $IP_DST"_TCP_full_"$VIS_DATE
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Perform weird TCP scans
        echo "[i] These scans requires root access: "
        sudo nmap -r -sN $IP_DST --top-ports 1000 -oA $IP_DST"_Null_top1000_"$VIS_DATE
        sudo nmap -r -sF $IP_DST --top-ports 1000 -oA $IP_DST"_FIN_top1000_"$VIS_DATE
        sudo nmap -r -sX $IP_DST --top-ports 1000 -oA $IP_DST"_Xmas_top1000_"$VIS_DATE
        sudo nmap -r -sA $IP_DST --top-ports 1000 -oA $IP_DST"_ACK_top1000_"$VIS_DATE
    fi
}

# UDP
function udp_checks(){
    echo "[i] UDP scan requires root access: "
    sudo nmap -r -sU --top-ports 1000 -oA $IP_DST"_UDP_top1000_"$VIS_DATE
}

# ICMP
function icmp_checks(){
    nmap -r -sn $IP_DST -oA $IP_DST"_ICMP_"$VIS_DATE
}

# IP protocol scan
function ip_checks(){
    echo "[i] IP protocol scan requires root access: "
    sudo nmap -r -sO --top-ports 1000 -oA $IP_DST"_IPProto_top1000_"$VIS_DATE
}

# Tcpdump for listening
function run_tcpdump(){
    echo "[i] tcpdump requires root access: "
    sudo tcpdump -i $CAP_INTERFACE -w $IP_SRC"_"$VIS_DATE -XX -vv src host $IP_SRC
}

# Menu
function run_menu(){
PS3='Please enter your choice: '
options=("TCP Scan" "UDP Scan" "ICMP scan" "All scans" "IP protocol scan" "Listen for incomming packets (tcpdump)" "Quit")
select opt in "${options[@]}"
do
initial_setup
    case $opt in
        "TCP Scan")
            set_ip_dst
            tcp_checks
            ;;
        "UDP Scan")
            set_ip_dst
            udp_checks
            ;;
        "ICMP scan")
            set_ip_dst
            icmp_checks
        ;;
        "All scans (Except IP scan)")
            set_ip_dst
            tcp_checks
            udp_checks
            ;;
        "IP protocol scan")
            set_ip_dst
            ipChecks
            ;;
        "Listen for incomming packets (tcpdump)")
            set_ip_src
            run_tcpdump
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
}
# /Menu

function main(){
    run_menu
}

main "$@"
