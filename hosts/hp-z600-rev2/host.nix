
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z9NB0KA08224V";

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };
}
