#!/usr/bin/env sh
sudo modprobe -r i2c_hid_acpi
sudo modprobe -r i2c_hid
sleep 1
sudo modprobe i2c_hid
sudo modprobe i2c_hid_acpi
