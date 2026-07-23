
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
          cors_domains = [
            "*"
#            "http://localhost:7126"
#            "http://127.0.0.1:7126"
#            "http://192.168.1.7:7126"
#            "http://caroline:7126"
          ];
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
            addr = "0.0.0.0";
            port = 7126;
          }
        ];
        extraConfig = ''
          allow 127.0.0.1;
          allow 192.168.1.0/24;
          deny all;
          client_max_body_size 1000m;
        '';
      };
    };
  };

  systemd.tmpfiles.rules = [
      "d /persist/var/lib/moonraker/logs 0755 moonraker moonraker -" # stop moonraker from crying like a baby
    ];

  networking.firewall.allowedTCPPorts = [
    7126
  ];
}
