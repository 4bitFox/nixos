{ config, pkgs, lib, ... }:


{
  home = {
    file = {
      ".config/xournalpp" = {
        source = ./homefiles/.config/xournalpp;
        recursive = true;
      };
    };
  };
}
