

{ config, pkgs, lib, home-manager, declarative-flatpak, ... }:


{
  imports = [
    home-manager.nixosModules.default # from flake
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit declarative-flatpak;
    };
  };
}
