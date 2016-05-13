#!/bin/bash

set -e
set -x


if [ ! -e print_mac.sh ] ; then
  echo "print_mac.sh not found"
  exit 1
fi

if [ ! -e 75-Dymo-LabelWriter-450.rules_template ] ; then
  echo "75-Dymo-LabelWriter-450.rules_template not found"
  exit 1
fi



# udev rules
sed -e "s:\[% SCRIPT %\]:`pwd`print_mac.sh:" ./75-Dymo-LabelWriter-450.rules_template  > /etc/udev/rules.d/75-Dymo-LabelWriter-450.rules


udevadm control --reload-rules

apt-get update
# install cups
apt-get install -y libcups2-dev libcupsimage2-dev g++ cups cups-client

# dymo drivers
apt-get install -y printer-driver-dymo


# add printer to cups
/usr/sbin/lpadmin -p DymoLW450 -E -v parallel:/dev/dymo_lw_450 -m dymo:0/cups/model/lw450.ppd

# set default printer
lpoptions -d DymoLW450

# QR code generator
apt-get install -y qrencode

# inkscape to convert svg to pdf
apt-get -y install inkscape
