
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

  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-configtool
        fcitx5-rose-pine
      ];
    };
  };
}
