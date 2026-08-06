
{ config, pkgs, lib, ... }:

let
  ### interfaces ###
  interfaces = {
    wan = "eno1";
  };

  ### network addresses ###
  addresses = {
    lan = {
      ip = "192.168.50.1";
      prefix = 24;
    };
    guest = {
      ip = "192.168.60.1";
      prefix = 24;
    };
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
    };
    guest = {
      name = "guest-br";
      interfaces = [
        "enp7s0f3"
      ];
    };
  };
in

{
  networking = {
    interfaces = {
      lan-br = {
        ipv4.addresses = [
          {
            address = addresses.lan.ip;
            prefixLength = addresses.lan.prefix;
          }
        ];
      };
      guest-br = {
        ipv4.addresses = [
          {
            address = addresses.guest.ip;
            prefixLength = addresses.guest.prefix;
          }
        ];
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
        )
        ++
        (map (bridge: "interface-name:${bridge.name}")
          (builtins.attrValues bridges)
        )
      ;
    };
  };
}
