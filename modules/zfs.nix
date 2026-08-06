
{ config, pkgs, lib, ... }:


{
  boot = {
    loader.grub.zfsSupport = true;
    supportedFilesystems = lib.mkAfter [ "zfs" ];
    zfs = {
      package = pkgs.zfs;
      unsafeAllowHibernation = false;
      removeLinuxDRM = true;
      forceImportRoot = false; # `boot.zfs.forceImportRoot` is using the default value of `true`. It is highly recommended to set it to `false`, the new default from 26.11 on, to reduce the risk of data loss.
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
    udev = {
      # hide individual zfs members in gui file managers showing ub billions of times
      # https://blog.vx.sk/archives/238
      # find properties with e.g. 'udevadm info --query=property --name=/dev/sda1'
      extraRules = ''
        ENV{ID_FS_TYPE}=="zfs_member", ENV{UDISKS_IGNORE}="1"
      '';
    };
  };
}
