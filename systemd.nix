
{ config, pkgs, lib, ... }:


{
  systemd = {
    sleep.extraConfig = ''
      SuspendState=freeze
    '';
  };
}
