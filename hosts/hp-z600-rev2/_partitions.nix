
{ config, pkgs, lib, ... }:


{
  boot = {  
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };

  fileSystems."/mnt/fd" = {
    device = "/dev/fd0";
    fsType = "vfat";
    options = [
      "rw"
      "users"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=1"
      "exec"
    ];
  };
}
