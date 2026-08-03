{ config, pkgs, lib, wl_shimeji, ... }:


{  
  home = {
    packages = [
      wl_shimeji.packages.${pkgs.system}.default
    ];
    activation.wl_shimeji = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -rf "$HOME/.local/share/wl_shimeji"
      mkdir -p "$HOME/.local/share/wl_shimeji"
      cp -r ${./homefiles/.local/share/wl_shimeji}/* "$HOME/.local/share/wl_shimeji/"
    '';
  };
}
