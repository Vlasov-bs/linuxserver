#!/bin/bash


HOSTNAME=$(hostname)
USER=$(whoami)
OS=$(hostnamectl | grep 'Operating System' | sed 's/.*: //')
DATE=$(date +"%d %B %Y %T")
UPTIME=$(uptime -p | sed 's/^up //')
UPTIME_SEC=$(awk '{print $1}' /proc/uptime)

TZ_NAME=$(timedatectl | grep 'Time zone' | awk '{print $3}')
TZ_OFFSET=$(date +"%z" | awk '{
  sign = substr($0,1,1)
  hours = substr($0,2,2) + 0
  mins = substr($0,4,2) + 0
  if (mins > 0)
    printf "%s%d:%02d", sign, hours, mins
  else
    printf "%s%d", sign, hours
}')
TIMEZONE="$TZ_NAME UTC $TZ_OFFSET"

IP=$(ip -4 addr show scope global | awk '/inet /{print $2}' | cut -d/ -f1 | head -1)
MASK=$(ifconfig | grep 'netmask' | grep -v '127.0.0.1' | awk '{print $4}')
GATEWAY=$(ip route | awk '/default/{print $3}' | head -1)

RAM_TOTAL=$(free | awk '/Mem:/{printf("%.3f", $2/1024/1024)}')
RAM_USED=$(free | awk '/Mem:/{printf("%.3f", $3/1024/1024)}')
RAM_FREE=$(free | awk '/Mem:/{printf("%.3f", $4/1024/1024)}')

SPACE_ROOT=$(df -B1 / | awk 'NR==2{printf("%.2f", $2/1024/1024)}')
SPACE_ROOT_USED=$(df -B1 / | awk 'NR==2{printf("%.2f", $3/1024/1024)}')
SPACE_ROOT_FREE=$(df -B1 / | awk 'NR==2{printf("%.2f", $4/1024/1024)}')