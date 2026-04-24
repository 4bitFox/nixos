
{ config, pkgs, lib, ... }:


{
  networking = {
    hostName = "aperture";
    networkmanager = {
      enable = true;
      # dns = "none"; # set to "none" for manual dns nameservers
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
    # nameservers = [
    #   "1.1.1.1" # Cloudflare
    #   "1.0.0.1" # Cloudflare
    #   "192.168.1.1" # home-network fallback
    # ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    enableIPv6 = true;
  };

  systemd.network.wait-online.enable = false;
}
