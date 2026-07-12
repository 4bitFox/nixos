
{ config, pkgs, lib, ... }:


{
  boot = {
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };

  ### ZFS ###

  networking.hostId = "9e40f792";

  ### ZFS (end) ###
}
