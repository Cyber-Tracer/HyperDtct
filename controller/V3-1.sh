#!/bin/bash
mkdir -p /media/usb_log_volume

if mount | grep -q "/media/usb_log_volume"; then
    echo "/media/usb_log_volume/ is already mounted."
else
    echo "/media/usb_log_volume/ is not mounted. Mounting now..."
    mount -t exfat /dev/sda /media/usb_log_volume/ -o rw,umask=0000
    if [ $? -eq 0 ]; then
        echo "Mount successful."
    else
        echo "Failed to mount /dev/sda to /media/usb_log_volume/."
        exit 1
    fi
fi

cd /home/logger/HyperDtct/controller/input

mkdir -p ../input_zipped/V3-1/

python3 to_zipped.py --directory V3-1/ --output_directory ../input_zipped/V3-1/

cd ..

mkdir -p /media/usb_log_volume/V3-1

su - logger -c "cd HyperDtct/controller && python3 start_server.py --input input_zipped/V3-1/ --log_dir /media/usb_log_volume/V3-1"

echo "Done logging!"

echo "Unmounting /dev/sda..."
sleep 5


umount /dev/sda/