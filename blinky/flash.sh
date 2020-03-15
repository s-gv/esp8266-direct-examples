#!/bin/bash


# Run this once! The addresses 0x3fe000 etc. are for 4MiB flash version of NodeMCUv3. See ESP8266 Getting Started guide for proper addresses if you have a different module. https://www.espressif.com/sites/default/files/documentation/2a-esp8266-sdk_getting_started_guide_en.pdf

ESP8266_NONOS_SDK_PATH='/home/sagar/ESP8266_NONOS_SDK-3.0'

#python -m esptool --port /dev/ttyUSB0 write_flash --flash_mode qio 0x3fb000 $ESP8266_NONOS_SDK_PATH/bin/blank.bin 0x3fc000 $ESP8266_NONOS_SDK_PATH/bin/esp_init_data_default_v08.bin 0x3fe000 $ESP8266_NONOS_SDK_PATH/bin/blank.bin


python -m esptool --port /dev/ttyUSB0 --baud 460800 write_flash --flash_mode qio 0x00000 eagle.flash.bin 0x10000 eagle.irom0text.bin

