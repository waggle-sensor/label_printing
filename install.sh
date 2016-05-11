#!/bin/bash

set -e
set -x

# udev rules
cp 75-Dymo-LabelWriter-450.rules /etc/udev/rules.d

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
