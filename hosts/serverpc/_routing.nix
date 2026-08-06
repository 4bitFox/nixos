
{ config, pkgs, lib, ... }:

let
  ### interfaces ###
  wan = "eno1";
  lan = [
    "enp7s0f0"
    "enp7s0f1"
    "enp7s0f2"
  ];
  guest = [
    "enp7s0f3"
  ];

  ### MAC-adresses of interfaces ###
  macs = {
    eno1 = "b4:2e:99:1f:e9:09";
    enp7s0f0 = "1c:fd:08:77:c5:14";
    enp7s0f1 = "1c:fd:08:77:c5:15";
    enp7s0f2 = "1c:fd:08:77:c5:16";
    enp7s0f3 = "1c:fd:08:77:c5:17";
  };
in

{
  networking = {
    interfaces = {
      lan-br = {
        ipv4.addresses = {
          address = "192.168.50.1";
          prefixLength = 24;
        };
      };
    };
    bridges = {
      ### LAN network ###
      lan-br = {
        interfaces = lan;
        rstp = false;
      };
    };
    networkmanager = {
      unmanaged = 
        (map (iface: "interface-name:${iface}") (lan ++ guest))
        ++ [
          "interface-name:lan-br"
        ]
      ;
    };
  };
}
