#!/bin/bash

#
# detect MAC address
#
MAC_ADDRESS=""
MODALIAS=""
for dev in /sys/class/net/eth? ; do
    MODALIAS=$(cat ${dev}/device/modalias)
    if [ "${MODALIAS}x" ==  "platform:meson-ethx" ] ; then
        MAC_ADDRESS=$(cat ${dev}/address)
        echo "MAC_ADDRESS: ${MAC_ADDRESS}"
        MAC_STRING=$(echo ${MAC_ADDRESS} | tr -d ":")
    fi 
done


if [ "${MAC_STRING}x" == "x" ]; then
  echo "mac address not found"
  exit 1
fi


# SVG size 1 corresponds to 1.02cm 
qrencode --type=SVG --output=/tmp/label.svg --level=H --ignorecase --size=1 ${MAC_STRING}

 
