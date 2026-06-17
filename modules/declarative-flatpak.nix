{ config, pkgs, lib, declarative-flatpak, ... }:


{
  imports = [
    declarative-flatpak.nixosModules.default
  ];

  services = {
    flatpak.enable = true;
  };

}
