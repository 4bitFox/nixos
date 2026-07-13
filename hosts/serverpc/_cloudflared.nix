
{ config, pkgs, lib, ... }:


{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "04ed5fa1-52fd-40fc-af8b-887ea055bab6" = {
        credentialsFile = "/data/cloudflared/token.txt";
        ingress = {
          "nextcloud.tschudibacon.com" = "https://localhost:8080";
        };

        default = "http_status:404";
      };
    };
  };
}
