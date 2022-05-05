#!/bin/bash

###### Architecture ######
echo "  # Architecture    : "
echo -n "        - operating system :"
hostnamectl | grep "Operating System" | cut -d':' -f2 2>/dev/null | tr -d '\n'
echo ""
echo -n "        - architecture     :"
hostnamectl | grep "Architecture" | cut -d':' -f2 2>/dev/null | tr -d '\n'
echo ""
echo -n "        - kernel version   :"
hostnamectl | grep "Kernel" | cut -d':' -f2 2>/dev/null | tr -d '\n'
echo ""

###### CPU physical ######
echo -n "  # CPU physical    : "
lscpu | grep "^CPU(s):" | awk '{print $2}' 2>/dev/null | tr -d '\n'
echo ""

###### vCPU ######
echo -n "  # vCPU            : "
THREAD=`lscpu | grep "^Thread(s) per core:" | awk '{print $4}' 2>/dev/null | tr -d '\n'`
CORE=`lscpu | grep "^Core(s) per socket:" | awk '{print $4}' 2>/dev/null | tr -d '\n'`
CPU=`lscpu | grep "^CPU(s):" | awk '{print $2}' 2>/dev/null | tr -d '\n'`
expr $THREAD \* $CORE \* $CPU 2>/dev/null | tr -d '\n'
echo ""

###### Memory Usage ######
echo -n "  # Memory Usage    : "
USED_MEM_MB=`free --mega | grep "^Mem:" | awk '{print $3}' 2>/dev/null | tr -d '\n'`
TOTAL_MEM_MB=`free --mega | grep "^Mem:" | awk '{print $2}' 2>/dev/null | tr -d '\n'`
echo -n "$USED_MEM_MB/$TOTAL_MEM_MB[MB]"
awk -v used=$USED_MEM_MB -v total=$TOTAL_MEM_MB 'BEGIN {printf(" (%.2f%%)", used/total*100)}' 2>/dev/null | tr -d '\n'
echo ""

###### Disk Usage ######
echo -n "  # Disk Usage      : "
USED_DISK=`df -h / | awk 'FNR == 2 {print $3}' 2>/dev/null | tr -d '\n'`
TOTAL_DISK=`df -h / | awk 'FNR == 2 {print $2}' 2>/dev/null | tr -d '\n'`
USED_PERCENT=`df -h / | awk 'FNR == 2 {print $5}' 2>/dev/null | tr -d '\n'`
echo -n "$USED_DISK/$TOTAL_DISK ($USED_PERCENT)"
echo ""

###### CPU load ######
echo -n "  # CPU load        : "
top -bn1 | grep '^%Cpu(s)' | awk '{print $2 + $4 "%"}' 2>/dev/null | tr -d '\n'
echo ""

###### Last boot ######
echo -n "  # Last boot       : "
who -b | awk '{print $3 " " $ 4}' 2>/dev/null | tr -d '\n'
echo ""

###### LVM use ######
echo -n "  # LVM use         : "
COUNT=`cat /etc/fstab 2>/dev/null | grep "/dev/mapper" | wc -l`
if [ $COUNT > 0 ]
then
	echo "yes"
else
	echo "no"
fi

###### Connections TCP ######
echo -n "  # Connections TCP : "
last | grep "still logged in" | wc -l | tr -d '\n'
echo " (ESTABLISHED)"

###### User log ######
echo -n "  # User log        : "
who | wc -l

###### Network ######
echo "  # Network         : "
echo -n "        - IPv4 address : "
ip addr | grep "enp0s3" | awk 'FNR==2 {print $2}' 2>/dev/null | sed 's/\/24//' | tr -d '\n'
echo ""
echo -n "        - MAC address  : "
ip link show | grep "link/ether" | awk '{print $2}' 2>/dev/null | tr -d '\n'
echo ""

###### Sudo ######
echo -n "  # Sudo            : "
cat /var/log/sudo/sudo.log 2>/dev/null | grep "COMMAND" | wc -l | tr -d '\n'
echo " cmd"
