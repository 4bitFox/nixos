
{ config, pkgs, lib, ... }:


{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      download-buffer-size = 536870912;
      min-free = 21474836480;
      min-free-check-interval = 5;
      show-trace = true;
      substitute = true;
      fallback = true;
      # max-jobs = "auto";
      max-jobs = 4;
      cores = 2;
      keep-going = true;
      sandbox = true;
    };
  };
}
