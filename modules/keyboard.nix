
{ config, pkgs, lib, ... }:


{
  ### keymap ###
  console = {
    keyMap = "sg";
  };
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };
}
