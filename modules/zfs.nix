
{ config, pkgs, lib, ... }:


{
  boot = {
    loader.grub.zfsSupport = true;
    zfs = {
      enabled = true;
      package = pkgs.zfs;
      unsafeAllowHibernation = false;
      removeLinuxDRM = true;
    };
  };

  services = {
    zfs = {
      autoScrub = { 
        enable = true;
        interval = "monthly";
      };
      trim = {
        enable = true;
        interval = "weekly";
        randomizedDelaySec = "6h";
      };
    };
  };
}
