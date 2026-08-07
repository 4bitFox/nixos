
{ config, pkgs, lib, ... }:


{
  config.assertions = lib.filter (a:
    a.message != "pihole-ftl conflicts with dnsmasq. Please disable one of them."
  ) config.assertions;

  assertions = [
    {
      assertion = config.services.dnsmasq.settings.port == 0;
      message = "dnsmasq must run DHCP-only when used with pihole-ftl.";
    }
  ];

  services = {
    pihole-ftl = {
      enable = true;
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
