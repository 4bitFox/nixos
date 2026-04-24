
{ config, pkgs, lib, ... }:


# Additional partitions-stuff to hardware-configuration.nix


{
  boot = {
    ### full disk encryption ###
    initrd.luks.devices = {
      luksroot = {
        # device = "/dev/disk/by-uuid/358b9e84-52cb-403c-b903-06ca33e3e520"; # adjust U>
        device = "/dev/disk/by-label/GLaDOS_luks"; # Make sure label is correct!
        preLVM = true;
        allowDiscards = true;
      };
    };

  ### swap ###
  resumeDevice = "/dev/dm-1"; # use "swapon -s" for path
  };
}
