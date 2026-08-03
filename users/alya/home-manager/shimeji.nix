{ config, pkgs, lib, ... }:


  
  file = {
      ".local/share/wl_shimeji" = {
        source = ./homefiles/.local/share/wl_shimeji;
        recursive = true;
      };
      ".local/opt/" = {
        source = ./homefiles/.local/opt/wl_shimeji;
        recursive = true;
      };
    };
  };
}
