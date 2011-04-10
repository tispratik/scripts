# sudo netstat --inet -pln
#
# address_family_options:
# [-4] [-6] [--protocol={inet,unix,ipx,ax25,netrom,ddp}[,...]]  [--unix|-x] [--inet|--ip] [--ax25] [--ipx] [--netrom] [--ddp]
#
# -p, --program
#       Show the PID and name of the program to which each socket belongs.
#
# -l, --listening
#       Show only listening sockets.  (These are omitted by default.)
#
# -n, --numeric
#       Show numerical addresses instead of trying to determine symbolic host, port or user names.

#!/bin/bash

IPT = /sbin/iptables

# Starting with a blank slate
$IPT -F		

# Setting default policies
$IPT -P OUTPUT ACCEPT
$IPT -P INPUT DROP
$IPT -P FORWARD DROP

# Allowed incoming traffic
$IPT -A INPUT --in-interface lo
$IPT -A INPUT -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -j ACCEPT
$IPT -I INPUT 1 -p tcp --dport 80 -j ACCEPT

# Allow Responses
$IPT -A INPUT -m state --state ESTABLISHED, RELATED -j ACCEPT
