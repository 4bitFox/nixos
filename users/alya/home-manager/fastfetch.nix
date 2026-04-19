{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/fastfetch/config.jsonc" = {
        source = ./homefiles/.config/fastfetch/config.jsonc;
      };
      ".config/fastfetch/logos" = {
        source = ./homefiles/.config/fastfetch/logos;
        recursive = true;
      };
    };
  };
}
