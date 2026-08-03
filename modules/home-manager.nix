

{ config, pkgs, lib, home-manager, declarative-flatpak, wl_shimeji, ... }:


{
  imports = [
    home-manager.nixosModules.default # from flake
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit declarative-flatpak;
      inherit wl_shimeji;
    };
  };
}
