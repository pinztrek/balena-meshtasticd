#!/bin/bash

if [ "$DEBUG" ];then
	DELAY=120
fi

if [ ! "$DELAY" ];then
	DELAY=5
fi

# check for spi
lsmod | grep -i spi
ls -l /dev/spi

# run the daemon
meshtasticd
echo "meshtasticd exited, sleeping $DELAY seconds"
sleep $DELAY