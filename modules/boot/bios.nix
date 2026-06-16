
{ config, pkgs, lib, ... }:



{
  boot = {
    loader = {
      grub = {
        gfxmodeBios = "auto";
        gfxpayloadBios = "keep";
      };
    };
  };
}
