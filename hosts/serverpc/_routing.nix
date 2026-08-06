
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
    };
  };

  bridgeNames = map (bridge: bridge.name) (builtins.attrValues bridges);

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
          (lib.flatten (map (bridge: bridge.interfaces) (builtins.attrValues bridges)))
        ) ++ 
        (map (bridge: "interface-name:${bridge}") bridgeNames)
      ;
    };

    nftables.enable = true;

    nat = {
      enable = true;
      externalInterface = interfaces.wan;
      internalInterfaces = bridgeNames;
    };

    firewall = {
      enable = true;
      # LAN is fully trusted (can reach the router's services, DNS, SSH, etc)
      trustedInterfaces = [ bridges.lan.name ];
      # Guest only gets what it needs: DHCP + DNS from the router
      interfaces.${bridges.guest.name} = {
        allowedUDPPorts = [ 53 67 ];
        allowedTCPPorts = [ 53 ];
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
}
