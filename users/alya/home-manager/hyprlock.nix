{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/hypr/hyprlock.conf" = {
        source = ./homefiles/.config/hypr/hyprlock.conf;
      };
    };
  };
}
