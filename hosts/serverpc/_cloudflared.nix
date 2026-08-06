
{ config, pkgs, lib, ... }:

# https://wiki.nixos.org/wiki/Cloudflared

{
  environment.systemPackages = with pkgs; [
    cloudflared
  ];
  
  services.cloudflared = {
    enable = true;
    tunnels = {
      "3b9593b0-983e-458a-a35c-9ede085ef3a0" = {
        credentialsFile = "/data/cloudflared/3b9593b0-983e-458a-a35c-9ede085ef3a0.json";
        ingress = {
          "nextcloud.tschudibacon.com/push/" = "http://localhost:7867";
          "nextcloud.tschudibacon.com" = "http://localhost:8080";
        };

        default = "http_status:404";
      };
    };
  };

  systemd.services.cloudflared-tunnel-3b9593b0-983e-458a-a35c-9ede085ef3a0 = {
    unitConfig = {
      StartLimitIntervalSec = 0;
    };
    serviceConfig = {
      RestartSec = 10;
    };
  };
}
