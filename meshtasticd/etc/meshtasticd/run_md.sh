#!/bin/bash

if [ "$DEBUG" ];then
	DELAY=120
fi

if [ ! "$DELAY" ];then
	DELAY=5
fi

# install a default config.yaml if needed
cd /etc/meshtasticd
if [ ! -f config.yaml && -f config-dist.yaml ]; then
	echo "Setup default config.yaml"
	cp config-dist.yaml config.yaml
 fi

 if [ "MESHTOAD" ]; then
 	rm config.d/*
 	cp available.d/lora-usb-meshtoad-e22.yaml config.d
  else
  	# assume waveshare
   	rm config.d/*
 	cp available.d/lora-waveshare-sxxx.yaml config.d
  fi
  	

# check for spi
lsmod 2>/dev/null | grep -i spi
ls -l "/dev/spi*" 2>/dev/null

# run the daemon
meshtasticd
echo "meshtasticd exited, sleeping $DELAY seconds"
sleep $DELAY
