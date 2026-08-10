
{ config, pkgs, lib, ... }:


{
  networking = {
    networkmanager = {
      enable = true;
      dns = "none"; # Manually set DNS nameservers instead.
      wifi.powersave = true;
    };
    ### manual DNS nameservers ###
    # useDHCP = false;
    # dhcpcd.enable = false;
    nameservers = [
      "127.0.0.1" # localhost (probably pihole)
    #  "1.1.1.1" # Cloudflare
    #  "1.0.0.1" # Cloudflare
    ];
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
