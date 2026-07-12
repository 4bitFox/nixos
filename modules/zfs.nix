
{ config, pkgs, lib, ... }:


{
  boot = {
    loader.grub.zfsSupport = true;
    supportedFilesystems = lib.mkAfter [ "zfs" ];
    zfs = {
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
