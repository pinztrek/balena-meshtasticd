# <kbd><img src="assets/images/balena-icon.png" alt="balena.io logo" width="60" style="border-radius:45%"/></kbd> <kbd><img src="meshtastic-logo.png" alt="meshtastic logo" width="60" style="border-radius:45%" /></kbd> balena-meshtasticd
This is a remix of Sam Eureka's balena-meshtasticd. Credit for the original goes to Sam, but much has changed that will likely never be incorporated back to the original, so it's more of a remix than fork.
Here's the original if interested, but it no longer works due to changes in the meshtastic firmware site: https://github.com/SamEureka/balena-meshtasticd

## The goal for this remix is to be able to standup a meshtasticd container, and completely manage it via balena cloud with a minimal of hand editing of config files and no container editing. 

## Key differences:
* Updated to utilize the currently maintained deb from the opensuse since it was removed from the meshtastic site
* A script is used to run meshtasticd, which allows for configuration variables, a sane default config, etc
* Debug mode is added which puts a sleep after the meshtasticd run to allow you to access the container for config changes
* The configuration file structure was made persistant and is read/write
* Current *config-dist.yaml* and config structures are pulled from (https://github.com/meshtastic/firmware/bin). If an existing *config.yaml* is not found one is created from *config-dist.yaml*. The *config.d* / *available.d* structure allows an easy selection of commonly supported devices. 
* You can reset to a default config via env variable
* Common devices can be selected by an env variable, or a specific one from the supported configs selected

# Usage:
## Create a free tier account at (https://dashboard.balena-cloud.com/login)

## Deploy by clicking the URL/Button below:
[![balena deploy button](assets/images/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/pinztrek/balena-meshtasticd) 
Or:(https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/pinztrek/balena-meshtasticd)

## Once logged into balena, it will create a fleet for *balena-meshtstasticd* 
## Create your device and download the disk image
* It will ask the device type, normally one of the Pi's. (Typically Pi3)
* Doanload the image and burn it to a microSD or EEMC with Balena Etcher or similar.
## Set Env variables for the fleet or device as needed below
* Recomended: set **DEBUG** to **1**, one of the presets like **MESHTOAD** or **WAVESHARE** to 1, or select a supported device for **LORA_DEVICE**. See notes on ENV variables below.
* You'll also likely want to set some radio options like **LORA_SANE_US**
## Load the microSD card into your device and power up
* The environment will download and startup.
* Once running you can then use the terminal window for the *meshtasticd* container to run radio setup commands, etc. Examples:
** *cd /etc/meshtasticd*
** *ls -l available.d*
** *cp available.d/filename.yaml config.d*


# Controlling the environment / application behavior with Env Variables:
Balena Device or Fleet environment variables can be used to set config and change behavior of a fleet or an individual device. 
* **DEBUG** set to 1 (or anything really) to enable a default 180 second sleep after meshtasticd exits to allow editing of config files.
* **LORA_DELAY** set to a value in seconds to create a custom delay. Overrides the **DEBUG** setting.
* **LORA_RESET** set to 1 to return the config folder to the default. Removes any selected devices in config.d and returns to the distribution config.yaml. Remember to unset after needed!
* **MESHTOAD** set to 1 to set the configuration to use a Meshtoad device
* **WAVESHARE** set to 1 to set the configuration to use a Waveshare device
* **LORA_DEVICE** set to the name of a supported device yaml file in the available.d directory
* **MAC_ETHER** set to 1 to set the mac address to be that of the ether interface (needed for waveshare)
* **GPS** set to desired gps serial device (Ex: Set GPS to /dev/ttyAMA0 or similar)

  
## Future meshtasticd Vars:
* **LORA_ADMIN** set to the public key of the node you want to have admin the target
* **GPS_NEBRA** set to 1 to enable kernel params to use the onboard u-blox gps on the Nebra HNT's and set the tty to the typical nebra one


# Configuring the radio:
The radio also has to have some base settings for meshtasticd to work. It does seem to apply defaults, but complains if they are not set. The meshtastic CLI is available on the container via ssh or access via the terminal on the balena cloud page. Setting any of the following variables creates a script /etc/meshtasticd/setradio.sh which can be executed to configure the radio. This is in a persistant location, so it can be rerun if needed. 

* **LORA_REG** set to the desired region (US, EU_433, etc.)
* **LORA_PRESET** set to desired LORA preset (LONG_FAST, etc.)
* **LORA_CHAN_URL** set to desired LORA channel url
* **LORA_SANE_US** set's the variables above to sane settings for the US (US, LONG_FAST, and the default Long-Fast channel)
Note that setting any of the flags above will recreate the script. Radio settings seem to be persistant, so you only have to set them once normally.

## Future radio params:
* Position setting script. Setting the vars below will populate a script you can run to hardcode the position.
** **SET_ALT** set to desired altitude
** **SET_LAT** set to desired altitude
** **SET_LON** set to desired altitude
* Radio config import & export scripts
** radio_export.sh to export current radio config to */etc/meshtasticd/radio.yaml* (or similar)
** radio_import.sh to import radio config from */etc/meshtasticd/radio.yaml* (or similar)

# Release versions
Any updates for **balena-meshtasticd* will be automatically deployed to your devices. If for some reason this creates issues you can pin to a prior release using the balena releases page. 

# Balena-Meshtasticd is an ideal way to run the cheap Nebra POE devices which have surfaced!
Information on how to use the inexpensive Nebra Helium miners that have become available can be found at: (https://github.com/pinztrek/nebra-hnt-meshtasticd)

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
