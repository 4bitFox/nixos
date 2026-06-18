
{ config, pkgs, lib, ... }:


{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
    opentabletdriver.enable = true;
    uinput.enable = true; # Required by OpenTabletDriver
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.opencl.enable = true;
    firmware = [
      pkgs.linux-firmware
    ];
    usbStorage.manageShutdown = true;
    usb-modeswitch.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    enableAllFirmware = true;
  };

  ### xpadneo ###
  hardware.xpadneo.enable = true;
  boot.kernelModules = [ "hid_xpadneo" ];

  powerManagement.enable = true;
}
