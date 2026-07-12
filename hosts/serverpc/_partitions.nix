
{ config, pkgs, lib, ... }:


{
  boot = {
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };

  fileSystems."/data" = {
    device = "data";
    fsType = "zfs";
  };
}
