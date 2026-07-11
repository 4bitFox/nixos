
{ config, pkgs, lib, ... }:


{
  boot = {
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-1"; # use "swapon -s" for path
  };
}
