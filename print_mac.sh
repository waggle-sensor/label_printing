#!/bin/bash


echo "Starting..." >> /print_mac.log
echo date >> /print_mac.log

#
# detect MAC address
#
MAC_ADDRESS=""
MODALIAS=""
for dev in /sys/class/net/eth? ; do
    MODALIAS=$(cat ${dev}/device/modalias)
    if [ "${MODALIAS}x" ==  "platform:meson-ethx" ] ; then
        MAC_ADDRESS=$(cat ${dev}/address)
        echo "MAC_ADDRESS: ${MAC_ADDRESS^^}"
        MAC_STRING=$(echo ${MAC_ADDRESS^^} | tr -d ":")
    fi 
done


if [ "${MAC_STRING}x" == "x" ]; then
  echo "mac address not found"
  exit 1
fi

rm -f /tmp/barcode.pdf /tmp/barcode.svg 

# generate barcode
# SVG size 1 corresponds to 1.02cm 
set -x
qrencode --type=SVG --output=/tmp/barcode.svg --level=H --ignorecase --size=1 ${MAC_STRING}
set +x

 

# modify svg and insert text

VIEWBOX_SIZE=$(cat /tmp/barcode.svg | grep "<svg" | grep -o 'viewBox="0 0 [0-9]* [0-9]*"' | cut -d ' ' -f 3)
echo "VIEWBOX_SIZE: ${VIEWBOX_SIZE}"
VIEWBOX_SIZE_DOUBLE=$(echo 2*${VIEWBOX_SIZE} | bc)
echo "VIEWBOX_SIZE_DOUBLE: ${VIEWBOX_SIZE_DOUBLE}"

TEXT_X=${VIEWBOX_SIZE}

LINE_1=$(echo "(${VIEWBOX_SIZE}/3)*0.9" | bc -l)
LINE_2=$(echo "(${VIEWBOX_SIZE}/3)*1.6" | bc -l)
echo "LINE_1: ${LINE_1}"
echo "LINE_2: ${LINE_2}"

set -x

sed -e 's_<svg width="[0-9]*.[0-9]*cm" height="[0-9]*.[0-9]*cm"_<svg width="2.2cm" height="1.1cm"_' \
-e "s@viewBox=\"0 0 [0-9]* [0-9]*\"@viewBox=\"0 0 ${VIEWBOX_SIZE_DOUBLE} ${VIEWBOX_SIZE}\"@" \
-e "s$</svg>$<text x=\"${TEXT_X}\" y=\"${LINE_1}\" style=\"font-style:normal;font-variant:normal;font-weight:bold;font-stretch:normal;font-size:8px;line-height:50%;font-family:'Courier New';-inkscape-font-specification:'Courier New Bold';text-align:start;writing-mode:lr-tb;text-anchor:start\" >${MAC_STRING:0:6}</text><text x=\"${TEXT_X}\" y=\"${LINE_2}\" style=\"font-style:normal;font-variant:normal;font-weight:bold;font-stretch:normal;font-size:8px;line-height:50%;font-family:'Courier New';-inkscape-font-specification:'Courier New Bold';text-align:start;writing-mode:lr-tb;text-anchor:start\" >${MAC_STRING:6}</text> </svg>$" \
/tmp/barcode.svg > /tmp/label.svg

# convert to pdf
inkscape --without-gui --export-pdf=/tmp/label.pdf /tmp/label.svg

# print
lp -o landscape -o media=Custom.13x25mm /tmp/label.pdf
