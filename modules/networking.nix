
{ config, pkgs, lib, ... }:


{
  networking = {
    networkmanager = {
      enable = true;
      # dns = "none";
      wifi.powersave = true;

      ### EDUROAM ###
      ensureProfiles.profiles = {
        eduroam = {
          connection = {
            id = "eduroam";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            ssid = "eduroam";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-eap";
          };
          "802-1x" = {
            eap = "peap";
            phase2-auth = "mschapv2";
            ca-cert = "/etc/ssl/certs/ca-bundle.crt";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
      ### EDUROAM (end) ###
    };
    ### manual DNS nameservers ###
    # useDHCP = false;
    # dhcpcd.enable = false;
    #nameservers = [
    #  "127.0.0.1" # localhost (probably pihole)
    #  "1.1.1.1" # Cloudflare
    #  "1.0.0.1" # Cloudflare
    #];
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowPing = true;
    };
    enableIPv6 = false;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
