
{ config, pkgs, lib, ... }:


{
  boot = {
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };

  networking.hostId = "9e40f792"; # required for ZFS
}
