# <kbd><img src="assets/images/balena-icon.png" alt="balena.io logo" width="60" style="border-radius:45%"/></kbd> <kbd><img src="meshtastic-logo.png" alt="meshtastic logo" width="60" style="border-radius:45%" /></kbd> balena-meshtasticd
This is a remix of Sam Eureka's balena-meshtasticd. Credit for the original goes to Sam, but much has changed that will likely never be incorporated back to the original, so it's more of a remix than fork.
Here's the original if interested, but it no longer works due to changes in the meshtastic firmware site: https://github.com/SamEureka/balena-meshtasticd

## Key differences:
* Updated to utilize the currently maintained deb from the opensuse since it was removed from the meshtastic site
* A script is used to run meshtasticd, which allows for configuration variables, a sane default config, etc
* Debug mode is added which puts a sleep after the meshtasticd run to allow you to access the container for config changes
* The configuration file structure was made persistant and is read/write
* Current config.yaml and config structures are leverage. This allows an easy selection of commonly supported devices
* You can reset to a default config via env variable
* Common devices can be selected by an env variable, or a specific one from the supported configs selected

# Deploy by clicking the URL/Button below:
[![balena deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=<https://github.com/pinztrek/balena-meshtasticd>) 
Or:(https://dashboard.balena-cloud.com/deploy?repoUrl=<https://github.com/pinztrek/balena-meshtasticd>)
Once logged into balena, it will create a fleet and you can create your device and download the disk image

# Env Variables:
Balena Device or Fleet environment variables can be used to set config and change behavior of a fleet or an individual device. 
* **DEBUG** set to 1 (or anything really) to enable a default 180 second sleep after meshtasticd exits to allow editing of config files.
* **LORA_DELAY** set to a value in seconds to create a custom delay. Overrides the **DEBUG** setting.
* **LORA_RESET** set to 1 to return the config folder to the default. Removes any selected devices in config.d and returns to the distribution config.yaml. Remember to unset after needed!
* **MESHTOAD** set to 1 to set the configuration to use a Meshtoad device
* **WAVESHARE** set to 1 to set the configuration to use a Waveshare device
* **LORA_DEVICE** set to the name of a supported device yaml file in the available.d directory

# Upcoming changes:
* Do initial meshtastic config at startup if **LORA_REGION**, **LORA_MODEM_PRESET**, and **LORA_CHANNEL_URL** are set and valid. Will likely have a region flag like **LORA_NA** that sets to sane defaults. (NA, Long Fast, and Long Fast channel)

# Balena-Meshtasticd is an ideal way to run the cheap Nebra POE devices which have surfaced!
I'll be documenting in a separate github: https://github.com/pinztrek/nebra-ont

# Sam Eureka's original info:
---

## :wrench: Hardware
_balena-meshtastic_ has been tested with the following devices:

***LoRa:***
* [Waveshare - SX1262 868/915M LoRaWAN/GNSS HAT - SKU: 24654](https://www.waveshare.com/sx1262-lorawan-hat.htm?sku=24654)
* [Adafruit - RFM95W LoRa Radio Transceiver Breakout - 868 or 915 MHz - SKU: 3072](https://www.adafruit.com/product/3072)

***SBC:***
* [Raspberry Pi Zero 2 W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/)
* [Raspberry Pi 3 Model B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/)

## :gear: Initial Device Configuration
> [!TIP]
> The Meshtastic Python CLI is installed by default. You can access it via the Terminal in the BalenaCloud dashboard.
>
> <img src="assets/images/balena-terminal-meshtastic.png" alt="balena terminal" width="650"/>

### :point_up: First things...
The minimal setup required is to set the region and preset. _You can chain the flags and settings on one line. exempli gratia,_ 
`meshtastic --set lora.region US --set lora.modem_preset LONG_FAST` 

|Setting|Usage|Description|
|--|--|--|
| --set lora.region | `meshtastic --set lora.region UNSET` | [LoRa Region Configuration Options](https://meshtastic.org/docs/configuration/radio/lora/) |
| --set lora.modem_preset | `meshtastic --set lora.modem_preset` | [LoRa modem presets](https://meshtastic.org/docs/configuration/radio/lora/#modem-preset) |
| --seturl | `meshtastic --seturl https://www.meshtastic.org/c/GAMiIE67C6zsNmlWQ-KE1tKt0fRKFciHka-DShI6G7ElvGOiKgZzaGFyZWQ=` | Set the channel URL, which contains LoRa configuration plus the configuration of channels. Replaces your current configuration and channels completely. |


### :zap: _Enjoy!_  
<img src="assets/images/pixel-sam.png" alt="sam image" width="40" /> //Sam
