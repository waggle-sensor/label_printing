# label_printing

This software will automatically print barcodes encoding the MAC address, as soon as the label printer is connected via USB.


# Installation

When the waggle image is used as the base image, stop the waggle-init process:

```bash
waggle-service stop waggle-init
```

Delete all init files (except waggle-epoch ?):
```bash
rm /etc/init/waggle-*
```

Install drivers and scripts:

```bash
git clone https://github.com/waggle-sensor/label_printing.git
cd label_printing/
./install.sh
```


