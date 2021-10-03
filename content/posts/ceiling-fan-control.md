---
date: 2021-10-03
title: Westinghouse ceiling fan remote control with Home Assistant
tags:
  - Home Automation
---

The Westinghouse Bendan ceiling fan comes with an infrared remote control (model number ID6) which is used to set the fan speed and turn the light on and off.

I've wanted to control the fan speed via my phone for a while, and have managed to do this using [Home Assistant][hass] and a [Broadlink RM3 Mini][rm3].

## Linking the RM3 Mini to Home assistant

Adding the RM3 Mini to Home Assistant was relatively simple - but don't bother with any of the instructions about setting up scripts as it's easier to set the codes manually. [Follow the guide][guide] otherwise.

Note that you will require your phone to be connected to an exclusively 2.4GHz WiFi network to set up the RM3 Mini - 2.4GHz and 5GHz WiFi on a single SSID will not work. Workarounds for this include walking away from your access point until your phone connects using the 2.4GHz band, setting up another 2.4GHz-only AP with the same SSID and password, or setting your APs to only broadcast 2.4GHz temporarily.

## Learning codes

_NB: you can try using my codes found below to save you from doing anything. Several models of this ceiling fan are available, and the one installed in my bedroom is one of the halogen models - if you have one of the LED models, your IR codes might be different._

With the RM3 Mini added to Home Assistant, it's now time to learn codes. The easiest way to do this is with [python-broadlink][pyblgh] ([available in the AUR][aur]). With that installed, run `broadlink_discovery` which will scan your LAN and discover any connected Broadlink devices. One of the lines of output will start with `# broadlink_cli` - copy this as it will ne needed to learn the IR codes.

Next, execute `broadlink_cli --type 0x5f36 --host 172.16.1.12 --mac 001122aabbcc --learn`, point the ceiling fan remote at the RM3 Mini and press a button on the remote. You IR codes will be printed to your terminal and those can be used in Home Assistant.

## Adding the fan to Home assistant

Adding fan actions to Home Assistant is - unfortunately - accomplished by adding each button as a switch. This is unfortunate because it makes state management a bit of a pain, but it works rather acceptably otherwise.

I've set my fan up like so:

- Light
  - On and off are the same command as the button on the remote is a toggle
- Fan
  - A generic "fan" switch for Google Home to catch so that simple "turn the fan on/off" commands works. The on command sets the fan speed to low.
  - A switch per fan speed for more granular control.

Adding the following `switch` block below to my Home Assistant `configuration.yaml` file, followed by a restart of Home Assistant, adds these switches and gives me remote control over my ceiling fan.

```yaml
switch:
  - platform: broadlink
    mac: 00:11:22:aa:bb:cc
    switches:
      - name: Bedroom fan light
        command_on: JgBoACMPKA8NKg8pDikOKQ8oDykqDQ0qDykOAAEGKA8oDw0qDykOKQ8oDygPKSgPDSoPKA8AAQYoDykODSsOKQ0qDSoNKwwrKA8NKg0rDAABCCgPKQ4NKw0qDSoNKg0rDikqDQ4pDykPAA0F
        command_off: JgBoACMPKA8NKg8pDikOKQ8oDykqDQ0qDykOAAEGKA8oDw0qDykOKQ8oDygPKSgPDSoPKA8AAQYoDykODSsOKQ0qDSoNKwwrKA8NKg0rDAABCCgPKQ4NKw0qDSoNKg0rDikqDQ4pDykPAA0F
      - name: Bedroom fan
        command_on: JgCSACQPKg0NKg0qDSsMKw0qDSoNKwwrDSop6ykPKg0NKg0qDSsMKw0qDSoNKwwrDSop6ykPKg0NKgwrDSsNKgwrDSoNKw0qDSop6ykPKg0MKw0qDSsNKg0qDSsMKw0qDCsp7CgPKg0OKQ0rDCsNKg0qDSsMKw0qDSop7CgPKg0OKQwsDCsNKg0qDSsNKgwrDSopAA0F
        command_off: JgCcACQPKA8NKg0qDSoNKw0qKQ4OKgwrDSoNAAEHKQ8pDgwrDSoNKw0qDSopDg8pDSoNKg0AAQcpDyoNDSoNKg0rDSoMKykODioNKg0qDAABCScQKA8NKg0rDCsNKg0qKQ8MKw0qDSoNAAEIKA8oDwwrDSsNKg0qDCspDwwrDSoNKg0AAQgoDykODCsNKw0qDSoNKigQDCsMKw0qDQANBQ==
      - name: Bedroom fan slow
        command_on: JgCSACQPKg0NKg0qDSsMKw0qDSoNKwwrDSop6ykPKg0NKg0qDSsMKw0qDSoNKwwrDSop6ykPKg0NKgwrDSsNKgwrDSoNKw0qDSop6ykPKg0MKw0qDSsNKg0qDSsMKw0qDCsp7CgPKg0OKQ0rDCsNKg0qDSsMKw0qDSop7CgPKg0OKQwsDCsNKg0qDSsNKgwrDSopAA0F
        command_off: JgCcACQPKA8NKg0qDSoNKw0qKQ4OKgwrDSoNAAEHKQ8pDgwrDSoNKw0qDSopDg8pDSoNKg0AAQcpDyoNDSoNKg0rDSoMKykODioNKg0qDAABCScQKA8NKg0rDCsNKg0qKQ8MKw0qDSoNAAEIKA8oDwwrDSsNKg0qDCspDwwrDSoNKg0AAQgoDykODCsNKw0qDSoNKigQDCsMKw0qDQANBQ==
      - name: Bedroom fan medium
        command_on: JgCcACYNKQ4NKgwrDSsNKg0qDSoNKyoNDSoPAAEFKQ8pDg0qDCwMKw0qDSoNKwwrKg0MKw0AAQgqDS0KDikNKw4pDCsNKg0rDSoqDQ4pDQABCCgPKQ4OKQ0rDSoNKg0qDSsNKikODikNAAEIKA8qDQ4qDCsNKg0qDSsMKw0qKQ4OKgwAAQgoDykODioNKg0qDCsNKwwrDSopDg4qDAANBQ==
        command_off: JgCcACQPKA8NKg0qDSoNKw0qKQ4OKgwrDSoNAAEHKQ8pDgwrDSoNKw0qDSopDg8pDSoNKg0AAQcpDyoNDSoNKg0rDSoMKykODioNKg0qDAABCScQKA8NKg0rDCsNKg0qKQ8MKw0qDSoNAAEIKA8oDwwrDSsNKg0qDCspDwwrDSoNKg0AAQgoDykODCsNKw0qDSoNKigQDCsMKw0qDQANBQ==
      - name: Bedroom fan fast
        command_on: JgCSACQOKQ8MKwwrDSopDwwrDCsNKg0rKA8o7CkOKQ8NKg0qDSopDwwrDSoNKg0rKA8o7CkOKw0NKg0qDSopDw0qDSoNKg0rKA8p6ykPKA8NKg0qDSsoDwwrDSoNKwwrKA8p6ykPKA8NKg0qDSsoDwwrDSoNKw0qKA8p6ykPKg0NKg0qDSsoDwwrDSsMKw0qKQ4pAA0F
        command_off: JgCcACQPKA8NKg0qDSoNKw0qKQ4OKgwrDSoNAAEHKQ8pDgwrDSoNKw0qDSopDg8pDSoNKg0AAQcpDyoNDSoNKg0rDSoMKykODioNKg0qDAABCScQKA8NKg0rDCsNKg0qKQ8MKw0qDSoNAAEIKA8oDwwrDSsNKg0qDCspDwwrDSoNKg0AAQgoDykODCsNKw0qDSoNKigQDCsMKw0qDQANBQ==
```

[hass]: https://www.home-assistant.io
[rm3]: https://www.ibroadlink.com/rmMini3
[guide]: https://www.home-assistant.io/integrations/broadlink
[aur]: https://aur.archlinux.org/packages/python-broadlink
[pyblgh]: https://github.com/mjg59/python-broadlink
