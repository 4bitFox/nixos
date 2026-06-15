
{ config, pkgs, lib, ... }:


{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
      };
    };
  };
}
