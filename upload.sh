#!/bin/sh

. ./.prepare

esptool.py --port $SERIAL_PORT erase_flash
sleep 1

esptool.py --port $SERIAL_PORT write_flash -fs 1MB -fm dout 0x0 tasmota-sensors.bin
sleep 3

stty -F $SERIAL_PORT $SERIAL_BAUD raw

tee $SERIAL_PORT <<EOF
Backlog \
Ssid1 $WIFI_SSID; \
Password1 $WIFI_PASSWORD; \
IPAddress1 $IP; \
IPAddress2 $GATEWAY; \
IPAddress3 $NETMASK; \
IPAddress4 $DNS; \
Module 0; \
Gpio2 29; \
Gpio4 6; \
Gpio5 5
EOF
