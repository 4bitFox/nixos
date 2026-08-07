
{ config, pkgs, lib, ... }:


{
  services = {
    pihole-ftl = {
      enable = false;
      settings = {
        # See <https://docs.pi-hole.net/ftldns/configfile/>
        dns.upstreams = [
          "1.1.1.1"
          "1.0.0.1"
          "127.0.0.53"
        ];
      };
    };
  };
}
