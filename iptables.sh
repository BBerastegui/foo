#!/bin/bash
IPTABLES=/sbin/iptables

#start and flush
$IPTABLES -F
$IPTABLES -X
$IPTABLES -t nat -F
$IPTABLES -t nat -X
$IPTABLES -t mangle -F
$IPTABLES -t mangle -X
$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT ACCEPT

$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH traffic
$IPTABLES -A INPUT -p tcp --dport 22 -j ACCEPT
# HTTP traffic
$IPTABLES -A INPUT -p tcp --dport 80 -j ACCEPT
# DNS
$IPTABLES -A INPUT -p tcp --dport 53 -j ACCEPT

# Remove comment to add more ports
# Example:
# $IPTABLES -A INPUT -p [PROTOCOL] --dport [PORT] -j ACCEPT

# Email
# $IPTABLES -A INPUT -p tcp --dport 25 -j ACCEPT
# $IPTABLES -A INPUT -p tcp --dport 587 -j ACCEPT
# $IPTABLES -A INPUT -p tcp --dport 143 -j ACCEPT

# HTTPS
$IPTABLES -A INPUT -p TCP --dport 443 -j ACCEPT
# RabbitMQ
# $IPTABLES -A INPUT -p TCP --dport 5672 -j ACCEPT

# loopback
iptables -A INPUT -i lo -p all -j ACCEPT

# Disable ipforward, respose to ping...
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.icmp_echo_ignore_all=0
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
