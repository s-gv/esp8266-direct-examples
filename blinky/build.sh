#!/bin/bash
set -e

ESP8266_NONOS_SDK_PATH='/home/sagar/ESP8266_NONOS_SDK-3.0'

# SPI_FLASH_SIZE_MAP=4 is for NodeMCUv3 with 4MiB of flash. Set SPI_FLASH_SIZE_MAP appropriately based on the flash size in your module

CFLAGS="-Os -g -Wpointer-arith -Wundef -Werror -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -ffunction-sections -fdata-sections -fno-builtin-printf -DICACHE_FLASH -DSPI_FLASH_SIZE_MAP=4"
IFLAGS="-I. -I$ESP8266_NONOS_SDK_PATH/include -I$ESP8266_NONOS_SDK_PATH/include/eagle -I$ESP8266_NONOS_SDK_PATH/driver_lib/include"
LFLAGS="-L$ESP8266_NONOS_SDK_PATH/lib -nostdlib -T$ESP8266_NONOS_SDK_PATH/ld/eagle.app.v6.ld"
LDFLAGS="-Wl,--no-check-sections -Wl,--gc-sections -u call_user_start -Wl,-static"
LIBS="-Wl,--start-group -lc -lgcc -lhal -lphy -lpp -lnet80211 -llwip -lwpa -lcrypto -lmain -ljson -lupgrade -lssl -lpwm -lsmartconfig -Wl,--end-group"


xtensa-lx106-elf-gcc $CFLAGS $IFLAGS $LFLAGS $LDFLAGS blinky.c $LIBS -o eagle.app.v6.out


#xtensa-lx106-elf-gcc -Os -g -Wpointer-arith -Wundef -Werror -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals -ffunction-sections -fdata-sections -fno-builtin-printf -DICACHE_FLASH -DSPI_FLASH_SIZE_MAP=4 -I ./ -I ../include -I ../include/eagle -I ../driver_lib/include -L../lib -nostdlib -T../ld/eagle.app.v6.ld -Wl,--no-check-sections -Wl,--gc-sections -u call_user_start -Wl,-static -Wl,--start-group -lc -lgcc -lhal -lphy -lpp -lnet80211 -llwip -lwpa -lcrypto -lmain -ljson -lupgrade -lssl -lpwm -lsmartconfig blinky.c -Wl,--end-group -o eagle.app.v6.out

xtensa-lx106-elf-objcopy --only-section .text -O binary eagle.app.v6.out eagle.app.v6.text.bin
xtensa-lx106-elf-objcopy --only-section .data -O binary eagle.app.v6.out eagle.app.v6.data.bin
xtensa-lx106-elf-objcopy --only-section .rodata -O binary eagle.app.v6.out eagle.app.v6.rodata.bin
xtensa-lx106-elf-objcopy --only-section .irom0.text -O binary eagle.app.v6.out eagle.app.v6.irom0text.bin


python $ESP8266_NONOS_SDK_PATH/tools/gen_appbin.py eagle.app.v6.out 0 0 0 0 0
mv eagle.app.flash.bin eagle.flash.bin
mv eagle.app.v6.irom0text.bin eagle.irom0text.bin
rm eagle.app.v6.*

echo "eagle.flash.bin-------->0x00000"
echo "eagle.irom0text.bin---->0x10000"

