# label_printing

This software will automatically print barcodes encoding the MAC address, as soon as the label printer is connected via USB.


# Installation

When the waggle image is used as the base image, stop the waggle-init process:

```bash
waggle-service stop waggle-init
```

Delete waggle init (except waggle-epoch):
```bash
ls -1 /etc/init/waggle-* | grep -v epoch | xargs -i rm {}
```

Install drivers and scripts:

```bash
git clone https://github.com/waggle-sensor/label_printing.git
cd label_printing/
./install.sh
```


