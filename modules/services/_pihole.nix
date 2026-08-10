
{ config, pkgs, lib, ... }:


{
  services = {
    pihole-ftl = {
      enable = true;
      useDnsmasqConfig = true;
      settings = {
        # See <https://docs.pi-hole.net/ftldns/configfile/>
        dns.upstreams = [  ]; # driven by dnsmasq.settings below instead. See below
        dhcp.active = false;
      };
      lists = [
        {
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          type = "block";
          enabled = true;
          description = "Steven Black's unified hosts";
        }
      ];
      openFirewallDNS = lib.mkDefault false;
    };
    
    pihole-web = {
      enable = true;
      ports = [ "5380" ];
    };

    dnsmasq.settings = {
      no-resolv = lib.mkDefault false;
      resolv-file = lib.mkDefault "/run/NetworkManager/resolv.conf";
      server = lib.mkDefault [ "1.1.1.1" "1.0.0.1" ];
      except-interface = lib.mkDefault [ "virbr0" ];
      bind-dynamic = lib.mkDefault true;
    };
  };
}
