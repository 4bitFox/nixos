{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/mako/config" = {
        source = ./homefiles/.config/mako/config;
      };
    };
  };
}
