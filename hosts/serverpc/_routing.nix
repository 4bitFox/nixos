
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
      dhcpRange = {
        start = "192.168.6.50";
        end = "192.168.6.154";
        lease = "48h";
      };
      firewallPorts = {
        tcp = [ 22 53 ];
        udp = [ 53 67 123 ];
      };
      firewallAllowOpenHostPorts = true;
      hosts = [
        { mac = "aa:bb:cc:dd:ee:01"; ip = "192.168.6.10"; name = "EXAMPLE1"; }
        { mac = "aa:bb:cc:dd:ee:02"; ip = "192.168.6.11"; name = "EXAMPLE2"; }
      ];
      portForwards = [
        # Ensure that the 'lanIp' is also defined in 'let bridges.*.hosts = [ ... ]; in' so it's static!
        { wanPort = 25565; lanPort = 25565; lanIp = "192.168.6.10"; proto = "tcp"; }
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
      dhcpRange = {
        start = "192.168.4.50";
        end = "192.168.4.154";
        lease = "6h";
      };
      firewallPorts = {
        tcp = [ 53 ];
        udp = [ 53 67 123 ];
      };
      firewallAllowOpenHostPorts = false;
      hosts = [ ];
      portForwards = [ ];
    };
  };

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
      interfaces = (
        builtins.listToAttrs (
          map (b: {
            name = b.name;
            value = {
              allowedTCPPorts =
                if b.firewallAllowOpenHostPorts or false
                then b.firewallPorts.tcp
                else lib.mkForce b.firewallPorts.tcp
              ;
              allowedUDPPorts =
                if b.firewallAllowOpenHostPorts or false
                then b.firewallPorts.udp
                else lib.mkForce b.firewallPorts.udp
              ;
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
      enable = true;
      resolveLocalQueries = false;   # don't let dnsmasq touch the host's own /etc/resolv.conf
      settings = {
        port = 0; # disable DNS, keep DHCP only. DNS will be handled by pihole
        interface = bridgeNames;     # lan-br, guest-br only — never eno1
        bind-interfaces = true;
        no-resolv = true;            # don't read /etc/resolv.conf for upstream either
        server = [ "1.1.1.1" "1.0.0.1" ];   # dnsmasq's own fixed upstream for LAN/guest queries
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
      };
    };

    timesyncd.enable = true; # NTP
  };
}
