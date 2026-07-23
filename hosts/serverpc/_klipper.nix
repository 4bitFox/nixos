
{ config, pkgs, lib, ... }:


{
  services = {
    klipper = {
      enable = true;
    };

    moonraker = {
      enable = true;
    };
  };
}
