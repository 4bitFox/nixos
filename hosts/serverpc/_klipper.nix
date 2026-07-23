
{ config, pkgs, lib, ... }:


{
  services = {
    klipper = {
      enable = true;
      configFile = klipper/printer.cfg;
    };

    moonraker = {
      enable = true;
      address = "127.0.0.1";
      port = 7125;
      settings = {
        # https://moonraker.readthedocs.io/en/latest/configuration/
        authorization = {
          trusted_clients = [
            "127.0.0.1"
            "192.168.1.0/24"
          ];
        };
      };
      allowSystemControl = false;
      stateDir = "/persist/var/lib/moonraker";
      user = "moonraker";
      group = "moonraker";
    };

    mainsail = {
      enable = true;
      nginx = {
        listen = [
          {
            port = 8081;
          }
        ];
        extraConfig = ''
          allow 192.168.1.0/24;
          deny all;
        '';
      };
    };
  };

  systemd.tmpfiles.rules = [
      "d /persist/var/lib/moonraker/logs 0755 moonraker moonraker -" # stop moonraker from crying like a baby
    ];
}
