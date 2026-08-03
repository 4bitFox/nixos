{ config, pkgs, lib, ... }:


{  
  home = {
    packages = [
      wl_shimeji.packages.${pkgs.system}.default
    ];
    file = {
      ".local/share/wl_shimeji" = {
        source = ./homefiles/.local/share/wl_shimeji;
        recursive = true;
      };
      ".local/opt/wl_shimeji" = {
        source = ./homefiles/.local/opt/wl_shimeji;
        recursive = true;
      };
    };
  };
}
