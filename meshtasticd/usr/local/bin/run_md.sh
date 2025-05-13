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

# Setup dirs as needed
if [ ! -d config.d ]; then
    mkdir config.d
fi

if [ ! -d available.d ]; then
    cp -r /etc/meshtasticd-dist/available.d .
fi

if [ ! -f config-dist.yaml ]; then
    cp -r /etc/meshtasticd-dist/config-dist.yaml .
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


if [ "$NEBRA" ]; then
    echo "We have a Nebra"
    GPS=/dev/ttyS0
    echo "GPS is $GPS"
    echo Use ethernet mac address
    mac_ether
fi

# Leave this in for now
if [ "$GPS" == "nebra" ]; then
    GPS=/dev/ttyS0
    echo "Nebra GPS enabled $GPS"
fi

if [ "$GPS" ]; then
    echo "Enable GPS $GPS"
	sed -i "s,#  SerialPath:.*$,  SerialPath: $GPS," $cfgdir/config.yaml
	sed -i "s,  SerialPath:.*$,  SerialPath: $GPS," $cfgdir/config.yaml
    grep -i serialpath $cfgdir/config.yaml
fi


# meshtastic commands have to be run after meshtasticd is up
set -x
# check for spi
lsmod 2>/dev/null | grep -i spi
ls -l "/dev/spi*" 2>/dev/null
set +x

if [ ! -d  '/root/.portduino/default/prefs' ]; then
    # precreate the default dir so portduino does not squawk
    mkdir -p ~root/.portduino/default/prefs #2>/dev/null
    ls -al /root/ 
    ls -al /etc/meshtasticd

    
fi


if [ "$LORA_SANE_US" ];then
	LORA_REG="US"
 	LORA_PRESET="LONG_FAST"
  	LORA_CHAN_URL="https://meshtastic.org/e/#CgMSAQESCAgBOAFAA0gB"
fi

#set -x
if [ "$LORA_REG" ]; then
  	#meshtastic --set lora.region "$LORA_REG"
  	mdstr="$mdstr --set lora.region $LORA_REG"
fi

if [ "$LORA_PRESET" ]; then
  	#meshtastic --set lora.modem_preset "$LORA_PRESET"
  	 mdstr="$mdstr --set lora.modem_preset $LORA_PRESET"
fi

# Queue some meshtastic commands to run in background
if [ "$mdstr" ]; then
    #echo "sleep 5; meshtastic $mdstr&"
    echo "sleep 5;meshtastic $mdstr" >> /tmp/setradio.sh
fi

# url is more problematic, do it separately
if [ "$LORA_CHAN_URL" ]; then
  	#meshtastic --set lora.modem_preset "$LORA_CHAN_URL"
  	 mdstr=" --ch-set-url $LORA_CHAN_URL"
    #echo "meshtastic $mdstr" >> /tmp/setradio.sh
    echo "sleep 5;meshtastic $mdstr" >> /tmp/setradio.sh
fi

if [ FALSE ]; then
#if [ -f /tmp/setradio.sh ]; then
    echo run the radio setup script
    cat /tmp/setradio.sh
    echo "Queue /tmp/setradio.sh"
    # disable for now, causes radio to reboot
    #bash /tmp/setradio.sh &
fi

if [ "$LORA_MAC_ETHER" ]; then
  	mac_ether
fi


echo "Starting meshtasticd"
# run the daemon
meshtasticd 

echo "meshtasticd exited, sleeping $LORA_DELAY seconds"
sleep "$LORA_DELAY"
