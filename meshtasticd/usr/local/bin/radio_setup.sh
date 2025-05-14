#!/bin/bash

cd /etc/meshtasticd

echo "Export current config to radio.last"
meshtastic --export-config > radio.last

# start with ones which do not reboot the radio

if [ "$LON" ]; then
    echo "Longitude set to $LON"
    SETTINGS="$SETTINGS --setlon $LON"
fi
    
if [ "$LAT" ]; then
    echo "Lattitude set to $LAT"
    SETTINGS="$SETTINGS --setlat $LAT"
fi
    
if [ "$ALT" ]; then
    echo "Altitude set to $ALT"
    SETTINGS="$SETTINGS --setalt $ALT"
fi

if [ "$NODEINFO" ]; then
    echo "Nodeinfo period set to $NODEINFO"
    SETTINGS="$SETTINGS --set device.nodeInfoBroadcastSecs $NODEINFO"
fi

if [ "$GPS_POSITION" ]; then
    echo "Nodeinfo period set to $GPS_POSITION"
    SETTINGS="$SETTINGS --set position.positionBroadcastSecs $GPS_POSITION"
fi


if [ "$LORA_ADMIN" ]; then
    echo "Setting Admin key $LORA_ADMIN"
    SETTINGS="$SETTINGS --set security.adminKey base64:$LORA_ADMIN"
fi

# Causes reboot

if [ "$LORA_OWNER" ]; then
    echo "Owner set to $LORA_OWNER"
    SETTINGS="$SETTINGS --set-owner $LORA_OWNER"
fi
    
if [ "$LORA_OWNER_SHORT" ]; then
    echo "Owner set to $LORA_OWNER_SHORT"
    SETTINGS="$SETTINGS --set-owner-short $LORA_OWNER_SHORT"
fi


if [ "$LORA_CH_URL" ]; then
    echo "Owner set to $LORA_CH_URL"
    SETTINGS="$SETTINGS --ch-set-url $LORA_CH_URL"
fi

if [ "$LORA_ROLE" ]; then
    echo "Owner set to $LORA_ROLE"
    SETTINGS="$SETTINGS --set device.role $LORA_ROLE"
fi


if [ "$GPS_MODE" ]; then
    echo "Setting GPS mode to $GPS_MODE"
    SETTINGS="$SETTINGS --set position.gps_mode $GPS_MODE"
fi

#if [ "$LAT" ] && [ "$LON" ]; then
    #echo "Lat & Lon are set, must want fixed position"
    #SETTINGS="$SETTINGS --set position.fixedPosition True"
#fi

    
#SETTINGS="--set lora.region US --set lora.modem_preset LONG_FAST --ch-set-url https://meshtastic.org/e/#CgMSAQESCAgBOAFAA0gB"

if [ ! "$SETTINGS" ]; then
    echo "Nothing to set!"
    exit
fi

echo "Setting radio to settings: /$SETTINGS/"

meshtastic  $SETTINGS

delay=15
echo "Sleeping $delay seconds to allow for reboot"
sleep "$delay"
meshtastic --export-config > radio.yaml
meshtastic --export-config 
