{ config, pkgs, lib, wl_shimeji, ... }:


{  
  home = {
    packages = with pkgs; [
      wl_shimeji.packages.${stdenv.hostPlatform.system}.default
    ];
    activation.wl_shimeji = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -rf "$HOME/.local/share/wl_shimeji"
      mkdir -p "$HOME/.local/share/wl_shimeji"
      cp -r ${./homefiles/.local/share/wl_shimeji}/* "$HOME/.local/share/wl_shimeji/"
      chmod -R u+rwX "$HOME/.local/share/wl_shimeji"
    '';
  };
}
