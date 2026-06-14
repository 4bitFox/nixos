{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/hyprpolkitagent/hyprpolkitagent.conf" = {
        source = ./homefiles/.config/hyprpolkitagent/hyprpolkitagent.conf;
      };
    };
  };
}
