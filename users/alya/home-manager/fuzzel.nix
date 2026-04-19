{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/fuzzel/fuzzel.ini" = {
        source = ./homefiles/.config/fuzzel/fuzzel.ini;
      };
    };
  };
}
