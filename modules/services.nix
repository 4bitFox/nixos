
{ config, pkgs, lib, ... }:


{
  services = {
    openssh.enable = true;
    dbus.enable = true;
    libinput.enable = true;
    udev = {
      ### HDD spindown ###
      extraRules = 
        let
          mkRule = as: lib.concatStringsSep ", " as;
          mkRules = rs: lib.concatStringsSep "\n" rs;
        in mkRules ([( mkRule [
          ''ACTION=="add|change"''
          ''SUBSYSTEM=="block"''
          ''KERNEL=="sd[a-z]"''
          ''ATTR{queue/rotational}=="1"''
          ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
      ])]);
      ### HDD spindown (end) ###
    };
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    tuned.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        wall.enable = true;
        systembus-notify.enable = true;
        test = true;
      };
    };
  };
}
