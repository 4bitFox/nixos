
{ config, pkgs, lib, ... }:

let
  ### interfaces ###
  interfaces = {
    wan = "eno1";
  };

  ### bridges ###
  bridges = {
    lan = {
      name = "lan-br";
      interfaces = [
        "enp7s0f0"
        "enp7s0f1"
        "enp7s0f2"
      ];
      address = {
        ip = "192.168.6.7";
        prefix = 24;
      };
      network = "192.168.6.0/24";
      dhcpRange = {
        start = "192.168.6.50";
        end = "192.168.6.154";
        lease = "48h";
      };
      firewallPorts = {
        tcp = [ 22 53 139 445 5357 7126 25565 35565 35568 ];
        udp = [ 53 67 123 137 138 3702 5353 ];
      };
      hosts = [
        { mac = "50:a1:32:52:e2:c0"; ip = "192.168.6.10"; name = "aperture_lan"; }
        { mac = "56:0f:cb:52:f1:f8"; ip = "192.168.6.11"; name = "aperture_wlan"; }
      ];
      portForwards = [
        # Ensure that the 'lanIp' is also defined in 'let bridges.*.hosts = [ ... ]; in' so it's static!
        { wanPort =   137; lanPort =   137; lanIp = "192.168.6.7"; proto = "udp"; }
        { wanPort =   138; lanPort =   138; lanIp = "192.168.6.7"; proto = "udp"; }
        { wanPort =   139; lanPort =   139; lanIp = "192.168.6.7"; proto = "tcp"; }
        { wanPort =   445; lanPort =   445; lanIp = "192.168.6.7"; proto = "tcp"; }
        { wanPort = 25565; lanPort = 25565; lanIp = "192.168.6.7"; proto = "tcp"; }
        { wanPort = 35565; lanPort = 35565; lanIp = "192.168.6.7"; proto = "tcp"; }
        { wanPort = 35568; lanPort = 35568; lanIp = "192.168.6.7"; proto = "tcp"; }
      ];
    };

    guest = {
      name = "guest-br";
      interfaces = [
        "enp7s0f3"
      ];
      address = {
        ip = "192.168.4.2";
        prefix = 24;
      };
      network = "192.168.4.0/24";
      dhcpRange = {
        start = "192.168.4.50";
        end = "192.168.4.154";
        lease = "6h";
      };
      firewallPorts = {
        tcp = [ 53 25565 35565 35568 ];
        udp = [ 53 67 123 ];
      };
      hosts = [ ];
      portForwards = [ ];
    };
  };

  dnsServers  = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  ntpServers = [
    "0.pool.ntp.org"
    "1.pool.ntp.org"
    "2.pool.ntp.org"
    "3.pool.ntp.org"
  ];

  bridgeNames = map (bridge: bridge.name) (builtins.attrValues bridges);
  allBridgeValues = builtins.attrValues bridges;
  allPortForwards = lib.flatten (map (b: b.portForwards or []) allBridgeValues);

in

{
  networking = {
    interfaces = builtins.listToAttrs (
      map (bridge: {
        name = bridge.name;
        value = {
          ipv4.addresses = [
            {
              address = bridge.address.ip;
              prefixLength = bridge.address.prefix;
            }
          ];
        };
      }) allBridgeValues
    );

    bridges = builtins.listToAttrs (
      map (bridge: {
        name = bridge.name;
        value = {
          interfaces = bridge.interfaces;
          rstp = true;
        };
      }) (builtins.attrValues bridges)
    );

    networkmanager = {
      unmanaged = 
        (map (iface: "interface-name:${iface}")
          (lib.flatten (map (bridge: bridge.interfaces) allBridgeValues))
        ) ++ 
        (map (bridge: "interface-name:${bridge}") bridgeNames)
      ;
    };

    nftables.enable = true;

    nat = {
      enable = true;
      externalInterface = interfaces.wan;
      internalInterfaces = bridgeNames;
      forwardPorts = 
        map (fw: {
          sourcePort = fw.wanPort;
          proto = fw.proto;
          destination = "${fw.lanIp}:${toString fw.lanPort}";
        }) allPortForwards
      ;
    };

    firewall = {
      enable = true;
      # Block general communication on all ports unless allowed
      allowedTCPPorts = lib.mkForce [ ];
      allowedUDPPorts = lib.mkForce [ ];
      interfaces = (
        builtins.listToAttrs (
          map (b: {
            name = b.name;
            value = {
              allowedTCPPorts = lib.mkForce b.firewallPorts.tcp;
              allowedUDPPorts = lib.mkForce b.firewallPorts.udp;
            };
          }
        ) allBridgeValues)
      ) // {
        ${interfaces.wan} = {
          allowedTCPPorts = lib.mkForce (
            map (fw: fw.wanPort) (builtins.filter (fw: fw.proto == "tcp") allPortForwards)
          );
          allowedUDPPorts = lib.mkForce (
            map (fw: fw.wanPort) (builtins.filter (fw: fw.proto == "udp") allPortForwards)
          );
        };
      };
      extraForwardRules = 
        # Drop communication between bridge networks.
        lib.concatMapStrings (a:
          lib.concatMapStrings (b:
            if a == b then "" else ''iifname "${a}" oifname "${b}" drop${"\n"}''
          ) bridgeNames
        ) bridgeNames
      ;
    };
  };

  boot.kernel.sysctl = 
    {
      "net.ipv4.ip_forward" = 1;
    } // builtins.listToAttrs (
      map (b: {
        name = "net.ipv6.conf.${b.name}.disable_ipv6";
        value = 1;
      }) allBridgeValues
    )
  ;

  services = {
    dnsmasq = {
      # enable = true;
      enable = lib.mkDefault (!config.services.pihole-ftl.enable); # pihole-ftl replaces the daemon; settings below still apply via useDnsmasqConfig
      resolveLocalQueries = false;   # don't let dnsmasq touch the host's own /etc/resolv.conf
      settings = {
        interface = bridgeNames;     # lan-br, guest-br only — never eno1
        bind-interfaces = true;
        bind-dynamic = lib.mkForce true; # override pihole default in my config so i can bind interfaces
        no-resolv = true;            # don't read /etc/resolv.conf for upstream either
        server = dnsServers;
        dhcp-range = 
          map (b: 
            "${b.name},${b.dhcpRange.start},${b.dhcpRange.end},${b.dhcpRange.lease}"
          ) allBridgeValues
        ;
        dhcp-option = lib.flatten (
          map (b: [
            "${b.name},3,${b.address.ip}" # gateway
            "${b.name},6,${b.address.ip}" # DNS
            "${b.name},42,${b.address.ip}" # NTP
          ]) allBridgeValues
        );
        domain-needed = true;
        bogus-priv = true;
        dhcp-host = lib.flatten (
          map (b: map (h: "${h.mac},${h.ip},${h.name}") (b.hosts or [])) allBridgeValues
        );
        dhcp-leasefile = lib.mkIf config.services.pihole-ftl.enable "/var/lib/pihole/dnsmasq.leases";
      };
    };

    pihole-ftl.openFirewallDNS = true;

    timesyncd.enable = false;

    chrony = {
      enable = true;
      servers = ntpServers;
      extraConfig = lib.concatMapStrings (b: "allow ${b.network}\n") allBridgeValues;
    };
  };
}
