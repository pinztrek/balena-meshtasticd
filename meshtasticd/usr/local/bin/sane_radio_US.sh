#!/bin/bash
SETTINGS="--set lora.region US --set lora.modem_preset LONG_FAST --ch-set-url https://meshtastic.org/e/#CgMSAQESCAgBOAFAA0gB"
echo "Setting radio to usable US settings: $SETTINGS"
meshtastic  $SETTINGS
