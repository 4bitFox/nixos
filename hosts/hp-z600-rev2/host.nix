{ config, pkgs, lib, ... }:


{
  imports = [  ];

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };
}
