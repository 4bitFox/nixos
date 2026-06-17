
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./_partitions.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KA08224V";

  ### NVIDIA GTX 1070 Ti ###
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
  };
  ### NVIDIA (end) ###

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };
}
