#!/bin/bash



apt-get update
# install cups
apt-get install -y libcups2-dev libcupsimage2-dev g++ cups cups-client

# dymo drivers
apt-get install -y printer-driver-dymo


# add printer to cups
/usr/sbin/lpadmin -p DymoLW450 -E -v parallel:/dev/usb/lp0 -m dymo:0/cups/model/lw450.ppd

# set default printer
lpoptions -d DymoLW450

# QR code generator
apt-get install -y qrencode

# inkscape to convert svg to pdf
apt-get -y install inkscape
