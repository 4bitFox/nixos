
{ config, pkgs, lib, ... }:


{
  services = {
    klipper = {
      enable = true;
      configFile = klipper/printer_voxelab-aquila.cfg;
      group = "klipper";
      firmwares = {
        mcu = {
          enable = true;
          configFile = klipper/klipper-firmware_voxelab-aquila.cfg;
          serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
          enableKlipperFlash = false;
        };
      };
    };

    moonraker = {
      enable = true;
      address = "127.0.0.1";
      port = 7125;
      settings = {
        authorization = {
          cors_domains = [
            "*" # 4 hours wasted till i figured this out... brahhhhh :c
          ];
          trusted_clients = [
            "127.0.0.1"
            # "192.168.1.0/24"
            "192.168.6.0/24"
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
          allow 192.168.6.0/24;
          # allow 192.168.1.0/24;
          deny all;
          client_max_body_size 1000m;
        '';
      };
    };
  };

  systemd.services = {
    klipper = {
      restartIfChanged = false;
    };
    moonraker.serviceConfig = {
      SupplementaryGroups = [ "klipper" ];
    };
  };

  system.activationScripts.klipperFirmwareLink = ''
    mkdir -p /persist/var/lib/klipper/firmware
    ln -sfn ${config.services.klipper.firmwares.mcu.package}/klipper.bin /persist/var/lib/klipper/firmware/klipper.bin
  '';

  systemd.tmpfiles.rules = [
      "d /persist/var/lib/moonraker/logs 0755 moonraker moonraker -" # stop moonraker from crying like a baby
      "d /persist/var/lib/moonraker/gcodes 0755 moonraker moonraker -"
    ];

  networking.firewall.allowedTCPPorts = [
    7126
  ];
}
