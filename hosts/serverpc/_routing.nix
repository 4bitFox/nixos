
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

    interfaces = {
      ${interfaces.wan} = {
        useDHCP = true;
      };
    };

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
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
}
