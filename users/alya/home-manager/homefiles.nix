{ config, pkgs, lib, ... }:


{
  home ={
    file = {
#      "Documents" = {
#        source = ./homefiles/Documents;
#        recursive = true;
#      };
      "Pictures" = {
        source = ./homefiles/Pictures;
        recursive = true;
      };
#      "Music" = {
#        source = ./homefiles/Music;
#        recursive = true;
#      };
#      "Downloads" = {
#        source = ./homefiles/Downloads;
#        recursive = true;
#      };
    };
  };
}
