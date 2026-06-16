{ config, pkgs, lib, ... }:


{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };
}
