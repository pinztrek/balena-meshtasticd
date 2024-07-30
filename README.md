# <img src="meshtastic-logo.png" alt="meshtastic logo" width="60" /> balena-meshtasticd
Meshtastic Linux Native Application with Charlie Unicorn magic on your PiZero W 2! 

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=<https://github.com/SamEureka/balena-meshtasticd>)

## Initial Device Configuration
> [!TIP]
> The Meshtastic Python CLI is installed by default. You can access it via the Terminal in the BalenaCloud dashboard.
> <img src="assets/images/balena-terminal-meshtastic.png" alt="balena terminal" width="150"/>

The first minimal setup, set the region and preset. You can chain the flags and settings on one line. Eg, `meshtastic --set lora.region US --set lora.modem_preset LONG_FAST` 

|Setting|Usage|Description|
|--|--|--|
| --set lora.region | `meshtastic --set lora.region UNSET` | [LoRa Region Configuration Options](https://meshtastic.org/docs/configuration/radio/lora/) |
| --set lora.modem_preset | `meshtastic --set lora.modem_preset` | [LoRa modem presets](https://meshtastic.org/docs/configuration/radio/lora/#modem-preset) |
| --seturl | `meshtastic --seturl https://www.meshtastic.org/c/GAMiIE67C6zsNmlWQ-KE1tKt0fRKFciHka-DShI6G7ElvGOiKgZzaGFyZWQ=` | Set the channel URL, which contains LoRa configuration plus the configuration of channels. Replaces your current configuration and channels completely. |

### _Enjoy!_

<img src="pixel-sam.png" alt="sam image" width="40" />
// Sam