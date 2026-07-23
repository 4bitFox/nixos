
{ config, pkgs, lib, ... }:


{
  services = {
    klipper = {
      enable = true;
      settings = {
        # https://www.klipper3d.org/Overview.html#configuration-and-tuning-guides
      };
      configDir = "/persist/var/lib/klipper";
      configFile = klipper/printer.cfg;
    };

    moonraker = {
      enable = true;
      address = "127.0.0.1";
      port = 7125;
      settings = {
        # https://moonraker.readthedocs.io/en/latest/configuration/
      };
      allowSystemControl = false;
      stateDir = "/persist/var/lib/moonraker";
    };
  };
}
