#!/bin/bash
cfgdir=/etc/meshtasticd

echo "Starting run_md.sh"

mac_ether () {
	
	echo "Setting MAC to ether"
	cp $cfgdir/config.yaml $cfgdir/config.last
	sed -i 's/#  MACAddressSource/  MACAddressSource/' $cfgdir/config.yaml
 	grep MAC $cfgdir/config.yaml
}

if [ "$LORA_DEBUG" ] && [ ! "$LORA_DELAY" ]; then
	LORA_DELAY=180
fi

if [ ! "$LORA_DELAY" ]; then
	LORA_DELAY=5
fi

# install a default config.yaml if needed
cd /etc/meshtasticd || exit
pwd

if [ "$LORA_RESET" ]; then
	if [ ! -d "$cfgdir"/config.last ];then
 		mkdir -p "$cfgdir"/config.last
        fi
	echo "Save Old Config in config.last"
        cp "$cfgdir"/config.d/* "$cfgdir"/config.last
     	cp "$cfgdir"/config.yaml "$cfgdir"/config.last
	echo "Deleting Old Config"
	rm -f config.d/*
	rm -f config.yaml
fi

if [ ! -f config.yaml ] && [ -f config-dist.yaml ]; then
	echo "Setup default config.yaml"
	cp config-dist.yaml config.yaml
fi

if [ "$MESHTOAD" ]; then
 	rm -f config.d/*
 	cp available.d/lora-usb-meshtoad-e22.yaml config.d
  	cfg_device="meshtoad"
fi
if [ "$WAVESHARE" ] && [ ! "$cfg_device" ]; then
   	rm -f config.d/*
 	cp available.d/lora-waveshare-sxxx.yaml config.d
  	cfg_device="waveshare"
   	# waveshare needs mac address
   	mac_ether
fi

if [ ! "$cfg_device" ] && [ "$LORA_DEVICE" ]; then
  	echo "See if $LORA_DEVICE exists"
    	if [ -f available.d/"$LORA_DEVICE" ]; then
     		echo "Select $LORA_DEVICE"
       		rm -f config.d/*
 		cp available.d/"$LORA_DEVICE" config.d
  		cfg_device="$LORA_DEVICE"
   	fi
fi


if [ "$GPS" ]; then
	sed -i 's/#  SerialPath:/  SerialPath:/' $cfgdir/config.yaml
fi


# meshtastic commands have to be run after meshtasticd is up
set -x
# check for spi
lsmod 2>/dev/null | grep -i spi
ls -l "/dev/spi*" 2>/dev/null
set +x

echo "Starting meshtasticd in background"
# run the daemon
meshtasticd &

if [ "$LORA_SANE_US" ];then
	LORA_REG="US"
 	LORA_PRESET="LONG_FAST"
  	LORA_CHAN_URL="https://meshtastic.org/e/#CgMSAQESCAgBOAFAA0gB"
fi
set -x
if [ "$LORA_REG" ]; then
  	meshtastic --set lora.region "$LORA_REG"
fi

if [ "$LORA_PRESET" ]; then
  	meshtastic --set lora.modem_preset "$LORA_PRESET"
fi
if [ "$LORA_CHAN_URL" ]; then
  	meshtastic --set lora.modem_preset "$LORA_CHAN_URL"
fi

if [ "$LORA_MAC_ETHER" ]; then
  	mac_ether
fi

echo "pull meshtasticd back into foreground"
fg       		
  	
echo "meshtasticd exited, sleeping $LORA_DELAY seconds"
sleep "$LORA_DELAY"
