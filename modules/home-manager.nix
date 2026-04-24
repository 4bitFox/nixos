

{ config, pkgs, lib, home-manager, declarative-flatpak, ... }:

#let
#  ### home-manager ###
#  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
#in

{
  imports = [
    #(import "${home-manager}/nixos")
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
