
{ config, pkgs, lib, ... }:


{
  boot = {
    ### full disk encryption ###
    initrd.luks.devices = {
      luksroot = {
        # device = "/dev/disk/by-uuid/358b9e84-52cb-403c-b903-06ca33e3e520"; # adjust UUID (use e.g. blkid command)!!!
        device = "/dev/disk/by-label/GLaDOS_luks"; # Make sure label is correct!
        preLVM = true;
        allowDiscards = true;
      };
    };
  
  ### swap ###
  resumeDevice = "/dev/dm-1"; # use "swapon -s" for path

  };

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
    xpadneo.enable = true;
    usbStorage.manageShutdown = true;
    usb-modeswitch.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    enableAllFirmware = true;
  };

  powerManagement.enable = true;
}
