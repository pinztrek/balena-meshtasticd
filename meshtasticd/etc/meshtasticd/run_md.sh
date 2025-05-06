#!/bin/bash

if [ "$DEBUG" ]; then
	DELAY=120
fi

if [ ! "$DELAY" ]; then
	DELAY=5
fi

# install a default config.yaml if needed
cd /etc/meshtasticd
pwd

if [ "$LORA_RESET" ]; then
	echo "Deleting Old Config"
	rm -f config.d/*
	rm -f config.yaml
 fi

if [ ! -f config.yaml && -f config-dist.yaml ]; then
	echo "Setup default config.yaml"
	cp config-dist.yaml config.yaml
 fi

 if [ "$MESHTOAD" ]; then
 	rm -f config.d/*
 	cp available.d/lora-usb-meshtoad-e22.yaml config.d
  	cfg-device = "meshtoad"
  fi
  if [ "$WAVESHARE" ]; then
   	rm -f config.d/*
 	cp available.d/lora-waveshare-sxxx.yaml config.d
  	cfg_device = "waveshare"
  fi

  if [ ! "$cfg_device" && "$LORA_DEVICE" ]; then
  	echo "See if $LORA_DEVICE exists
    	if [ -f available.d/"$LORA_DEVICE" ]; then
     		echo "Select $LORA_DEVICE"
       		rm -f config.d/*
 		cp available.d/"$LORA_DEVICE" config.d
  		cfg_device = "$LORA_DEVICE"
   	fi
    fi
       		
  	

# check for spi
lsmod 2>/dev/null | grep -i spi
ls -l "/dev/spi*" 2>/dev/null

# run the daemon
meshtasticd
echo "meshtasticd exited, sleeping $DELAY seconds"
sleep $DELAY
