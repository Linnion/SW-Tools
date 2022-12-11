#!/bin/bash

#find IP address of Raspberry Pi, save to a variale named rPiIP.
rPiIP=$(ifconfig eth0 | grep -w inet | awk '{print $2}')

#Read the current date/time, save it to variable srfile.
srfilename=$(date +"%Y_%m_%d_%H_%M_%S").txt

#Write IP to a file named from srfile.
srfile="/home/"$(who am i | awk '{print $1}')"/Scans/"$srfilename

#Print IP to console and srfile.
echo "Scanbox's IP is "$rPiIP | tee -a $srfile
echo "" | tee -a $srfile

#Read rPiIP into an array named 'RPIP', separating each octet into its own element.
IFS='.' read -a RPIP <<< $rPiIP

#Read the first three octets of the IP address into a variable named 'IPrange' and add a wildcard for the fourth.
IPrange=${RPIP[0]}"."${RPIP[1]}"."${RPIP[2]}".*"

#Print IP range to console and to srfile.
echo "IP range is "$IPrange | tee -a $srfile
echo "" | tee -a $srfile

#Perform an ARP scan of all devices in the Scanbox's local range. Print results to console and to srfile.
arp-scan -l | tee -a $srfile
echo "" | tee -a $srfile

#Scan Scanbox's local range for open ports. Print results to console and to srfile.
nmap -PR -O -osscan-guess -oN $srfile --append-output 192.168.1.1/24 #$IPrange

