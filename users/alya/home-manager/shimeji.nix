{ config, pkgs, lib, wl_shimeji, ... }:


{  
  home = {
    packages = [
      wl_shimeji.packages.${pkgs.system}.default
    ];
    #file = {
      #".local/share/wl_shimeji" = {
      #  source = ./homefiles/.local/share/wl_shimeji;
      #  recursive = true;
      #};
      #".local/opt/wl_shimeji" = {
      #  source = ./homefiles/.local/opt/wl_shimeji;
      #  recursive = true;
      #};
    #};
    activation.wl_shimeji = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -rf "$HOME/.local/share/wl_shimeji"
      mkdir -p "$HOME/.local/share/wl_shimeji"
      cp -r ${./homefiles/.local/share/wl_shimeji}/* "$HOME/.local/share/wl_shimeji/"
    '';
  };
}
