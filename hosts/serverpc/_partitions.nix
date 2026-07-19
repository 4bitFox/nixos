
{ config, pkgs, lib, ... }:


{
  boot = {
    ### swap for hibernation ###
    resumeDevice = "/dev/dm-0"; # use "swapon -s" for path
  };

  boot.zfs.extraPools = [ "data" ];

  fileSystems = {
    "/backup" = {
      device = "/dev/disk/by-uuid/205c59a3-7ff1-48f7-bcd7-fa7069e06fbf";
      fsType = "ext4";
      options = [
        "nofail"
        "x-systemd.automount"
        "x-systemd.idle-timeout=10s"
      ];
    };
  };
}
