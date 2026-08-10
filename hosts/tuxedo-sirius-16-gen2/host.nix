
{ config, pkgs, lib, ... }:


{
  imports = [
    ./_partitions.nix
    ./specialisations/_fhnw.nix
  ];

  nix = {
    settings = {
      max-jobs = 4;
      cores = 2;
    };
  };


  hardware = {
    tuxedo-drivers.enable = true;
  };

  systemd = {
    sleep.settings.Sleep = {
      SuspendState = "freeze";
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

  # boot.initrd.kernelModules = [ "amdgpu" ];

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
