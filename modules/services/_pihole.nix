
{ config, pkgs, lib, ... }:


{
  services = {
    pihole-ftl = {
      enable = true;
      useDnsmasqConfig = true;
      settings = {
        # See <https://docs.pi-hole.net/ftldns/configfile/>
        dns.upstreams = [
          "1.1.1.1"
          "1.0.0.1"
        ];
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
    };
    
    pihole-web = {
      enable = true;
      ports = [ "5380" ];
    };
  };
}
