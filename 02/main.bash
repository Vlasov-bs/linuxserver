#!/bin/bash

chmod +x main.bash

HOSTNAME=$(hostname)
TIMEZONE=$(timedatectl | grep 'zone:' | awk '{print $3}')
OS=$(hostnamectl | grep 'Operating' | awk '{print $3, $4, $5}')
UPTIME=$(uptime -p | sed 's/^up*\s*//')
UPTIME_SEC=$(cat /proc/uptime | awk '{print $1}')
IP=$(ifconfig | grep 'netmask' | grep -v '127.0.0.1' | awk '{print $2}')
MASK=$(ifconfig | grep 'netmask' | grep -v '127.0.0.1' | awk '{print $4}')
GATEWAY=$(ip route | grep 'default' | awk '{print $3}')
RAM_TOTAL=$(free | grep 'Mem:' | awk '{printf("%.3f", $2/1024/1024);}')
RAM_USED=$(free | grep 'Mem:' | awk '{printf("%.3f", $3/1024/1024);}')
RAM_FREE=$(free | grep 'Mem:' | awk '{printf("%.3f", $4/1024/1024);}')
SPACE_ROOT=$(df -B1 | awk 'NR==2{printf("%.2f", $2/1024/1024)}')
SPACE_ROOT_USED=$(df -B1 | awk 'NR==2{printf("%.2f", $3/1024/1024)}')
SPACE_ROOT_FREE=$(df -B1 | awk 'NR==2{printf("%.2f", $4/1024/1024)}')

OFFSET=$(date +"%z")

sign=${OFFSET:0:1}
hours=$((10#${OFFSET:1:2}))
minutes=${OFFSET:3:2}        

if [ "$minutes" != "00" ]; then
    TIMEZONE="UTC ${sign}${hours}:${minutes}"
else
    TIMEZONE="UTC ${sign}${hours}"
fi

echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $TIMEZONE"
echo "USERNAME = $(whoami)"
echo "OS = $OS"
echo "DATE = $(date +"%d %B %Y %T")"
echo "UPTIME = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"
echo "IP = $IP"
echo "MASK = $MASK"
echo "GATEWAY = $GATEWAY"
echo "RAM_TOTAL = $RAM_TOTAL GB"
echo "RAM_USED = $RAM_USED GB" 
echo "RAM_FREE = $RAM_FREE GB"
echo "SPACE_ROOT = $SPACE_ROOT MB"
echo "SPACE_ROOT_USED = $SPACE_ROOT_USED MB"
echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE MB"

read -p "Wrire data to a file? (Y/N) "

if [[ $REPLY =~ ^[Y|y]$ ]]; then
filename="$(date +"%d_%m_%y_%H_%M_%S").status"
{
echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $TIMEZONE"
echo "USERNAME = $(whoami)"
echo "OS = $OS"
echo "DATE = $(date +"%d %B %Y %T")"
echo "UPTIME = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"
echo "IP = $IP"
echo "MASK = $MASK"
echo "GATEWAY = $GATEWAY"
echo "RAM_TOTAL = $RAM_TOTAL GB"
echo "RAM_USED = $RAM_USED GB" 
echo "RAM_FREE = $RAM_FREE GB"
echo "SPACE_ROOT = $SPACE_ROOT MB"
echo "SPACE_ROOT_USED = $SPACE_ROOT_USED MB"
echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE MB"
} > filename
echo "Data is saved successfully!"
else
echo "Data will not be saved."
fi
