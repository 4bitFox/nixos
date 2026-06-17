
{ config, pkgs, lib, ... }:


{
  ### swap for hibernation ###
  resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };
}
