
{ config, pkgs, lib, ... }:


{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

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
      ];
    };
    "/home/alya/Network/share" = {
      device = "//127.0.0.1/share";
      fsType = "cifs";
      options = [
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1h"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "credentials=/home/alya/.smb-share.secret"
        "uid=1000"
        "gid=100"
      ];
    };
    "/danger" = {
      device = "/dev/disk/by-uuid/a2ae99f4-a133-4fde-81d8-d6acdfc6cf6b";
      fsType = "ext4";
      options = [
        "nofail"
        "x-systemd.automount"
      ];
    };
  };
}
