#!/bin/bash

## Architecture ##
OS=`hostnamectl | grep "Operating System" | cut -d':' -f2 2>/dev/null`
ARCH=`hostnamectl | grep "Architecture" | cut -d':' -f2 2>/dev/null`
KERNEL=`hostnamectl | grep "Kernel" | cut -d':' -f2 2>/dev/null`

## CPU physical ##
CPU_PHYSI=`lscpu | grep "^CPU(s):" | awk '{print $2}' 2>/dev/null`

## vCPU ##
THREAD=`lscpu | grep "^Thread(s) per core:" | awk '{print $4}' 2>/dev/null | tr -d '\n'`
CORE=`lscpu | grep "^Core(s) per socket:" | awk '{print $4}' 2>/dev/null | tr -d '\n'`
CPU=`lscpu | grep "^CPU(s):" | awk '{print $2}' 2>/dev/null | tr -d '\n'`
VCPU=`expr $THREAD \* $CORE \* $CPU 2>/dev/null`

## Memory Usage ##
USED_MEM_MB=`free --mega | grep "^Mem:" | awk '{print $3}' 2>/dev/null | tr -d '\n'`
TOTAL_MEM_MB=`free --mega | grep "^Mem:" | awk '{print $2}' 2>/dev/null | tr -d '\n'`
MEM_PERCENT=`awk -v used=$USED_MEM_MB -v total=$TOTAL_MEM_MB 'BEGIN {printf(" (%.2f%%)", used/total*100)}' 2>/dev/null`
MEMORY_USAGE="$USED_MEM_MB/$TOTAL_MEM_MB[MB] $MEM_PERCENT"

## Disk Usage ##
USED_DISK=`df -h / | awk 'FNR == 2 {print $3}' 2>/dev/null | tr -d '\n'`
TOTAL_DISK=`df -h / | awk 'FNR == 2 {print $2}' 2>/dev/null | tr -d '\n'`
USED_PERCENT=`df -h / | awk 'FNR == 2 {print $5}' 2>/dev/null | tr -d '\n'`
DISK_USAGE="$USED_DISK/$TOTAL_DISK ($USED_PERCENT)"

## CPU load ##
CPU_LOAD=`top -bn1 | grep '^%Cpu(s)' | awk '{print $2 + $4 "%"}' 2>/dev/null`

## Last boot ##
LAST_BOOT=`who -b | awk '{print $3 " " $ 4}' 2>/dev/null`

## LVM use ##
LVM_USE="no"
COUNT=`cat /etc/fstab 2>/dev/null | grep "/dev/mapper" | wc -l`
if [ $COUNT > 0 ]
then
	LVM_USE="yes"
fi

## Connections TCP ##
CONN_TCP=`last | grep "still logged in" | wc -l`

## User log ##
USER_LOG=`who | wc -l`

## Network ##
IP=`ip addr | grep "enp0s3" | awk 'FNR==2 {print $2}' 2>/dev/null | sed 's/\/24//'`
MAC=`ip link show | grep "link/ether" | awk '{print $2}' 2>/dev/null`

## Sudo ##
SUDO=`cat /var/log/sudo/sudo.log 2>/dev/null | grep "COMMAND" | wc -l`

#### Printout ####
wall "  # Architecture    :
        - operating system : $OS
	- architecture     : $ARCH
	- kernel version   : $KERNEL
  # CPU physical    : $CPU_PHYSI
  # vCPU            : $VCPU
  # Memory Usage    : $MEMORY_USAGE
  # Disk Usage      : $DISK_USAGE
  # CPU load        : $CPU_LOAD
  # Last boot       : $LAST_BOOT
  # LVM use         : $LVM_USE
  # Connections TCP : $CONN_TCP (ESTABLISHED)
  # User log        : $USER_LOG
  # Network         :
 	- IPv4 address : $IP
	- MAC address : $MAC
  # Sudo            : $SUDO cmd"