{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/waybar/config.jsonc" = {
        source = ./homefiles/.config/waybar/config.jsonc;
      };
      ".config/waybar/style.css" = {
        source = ./homefiles/.config/waybar/style.css;
      };
      ".config/waybar/power_menu.xml" = {
        source = ./homefiles/.config/waybar/power_menu.xml;
      };
    };
  };
}
