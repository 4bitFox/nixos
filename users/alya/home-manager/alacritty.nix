{ config, pkgs, lib, ... }:


{
  home ={
    file = {
      ".config/alacritty/alacritty.toml" = {
        source = ./homefiles/.config/alacritty/alacritty.toml;
      };
    };
  };
}
