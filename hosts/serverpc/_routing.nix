
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
        ip = "192.168.50.1";
        prefix = 24;
      };
      hosts = [
        { mac = "aa:bb:cc:dd:ee:01"; ip = "192.168.50.10"; name = "EXAMPLE1"; }
        { mac = "aa:bb:cc:dd:ee:02"; ip = "192.168.50.11"; name = "EXAMPLE2"; }
      ];
      portForwards = [
        { wanPort = 25565; lanPort = 25565; lanIp = "192.168.50.10"; proto = "tcp"; }
      ];
    };
    guest = {
      name = "guest-br";
      interfaces = [
        "enp7s0f3"
      ];
      address = {
        ip = "192.168.60.1";
        prefix = 24;
      };
      hosts = [ ];
      portForwards = [ ];
    };
  };

  bridgeNames = map (bridge: bridge.name) (builtins.attrValues bridges);
  allBridgeValues = builtins.attrValues bridges;
  allPortForwards = lib.flatten (map (b: b.portForwards) allBridgeValues);

in

{
  networking = {
    ### generate from let in ###
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
      }) (builtins.attrValues bridges)
    );

    bridges = builtins.listToAttrs (
      map (bridge: {
        name = bridge.name;
        value = {
          interfaces = bridge.interfaces;
          rstp = false;
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
    ### generate from let in (end) ###

    nftables.enable = true;

    nat = {
      enable = true;
      externalInterface = interfaces.wan;
      internalInterfaces = bridgeNames;
    };

    firewall = {
      enable = true;
      interfaces = {
        ${bridges.lan.name} = {
          allowedUDPPorts = [ 53 67 ];
          allowedTCPPorts = [ 22 53 ];
        };
        ${bridges.guest.name} = {
          allowedUDPPorts = lib.mkForce [ 53 67 ];
          allowedTCPPorts = lib.mkForce [ 53 ];
        };
        # Block inbound traffic on all ports on WAN
        ${interfaces.wan} = {
          allowedTCPPorts = lib.mkForce [ ];
          allowedUDPPorts = lib.mkForce [ ];
        };
      };
      # Block guest <-> lan traffic in the forwarding path
      extraForwardRules = ''
        iifname "${bridges.guest.name}" oifname "${bridges.lan.name}" drop
        iifname "${bridges.lan.name}" oifname "${bridges.guest.name}" drop
      '';
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  services = {
    dnsmasq = {
      enable = true;
      resolveLocalQueries = false;   # don't let dnsmasq touch the host's own /etc/resolv.conf
      settings = {
        interface = bridgeNames;     # lan-br, guest-br only — never eno1
        bind-interfaces = true;

        no-resolv = true;            # don't read /etc/resolv.conf for upstream either
        server = [ "1.1.1.1" "1.0.0.1" ];   # dnsmasq's own fixed upstream for LAN/guest queries

        dhcp-range = [
          "${bridges.lan.name},192.168.50.50,192.168.50.150,24h"
          "${bridges.guest.name},192.168.60.50,192.168.60.150,24h"
        ];
        dhcp-option = [
          "${bridges.lan.name},3,${bridges.lan.address.ip}"
          "${bridges.lan.name},6,${bridges.lan.address.ip}"
          "${bridges.guest.name},3,${bridges.guest.address.ip}"
          "${bridges.guest.name},6,${bridges.guest.address.ip}"
        ];
        domain-needed = true;
        bogus-priv = true;
        dhcp-host = lib.flatten (
          map (b: map (h: "${h.mac},${h.ip},${h.name}") b.hosts) allBridgeValues
        );
      };
    };
  };
}
