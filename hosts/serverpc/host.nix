
{ config, pkgs, lib, ... }:


{
  imports = [
    ./_partitions.nix
    ./_samba.nix
    ./_nextcloud.nix
    ./_cloudflared.nix
    ./_mariadb.nix
  ];

  networking.hostId = "9e40f792"; # required for ZFS

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };


  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm; # Use AMD GPU for ollama
      loadModels = [
        # general
        "llama3.1:8b"
        # reasoning
        "deepseek-r1:8b"
      ];
      syncModels = true;
      rocmOverrideGfx = "11.0.2";
    };
    protonmail-bridge.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      radeontop
      rocmPackages.rocminfo
      protonmail-bridge-gui
    ];
    variables = {
      RUSTICL_ENABLE = "radeonsi";
    };
  };  
}
