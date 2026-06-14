
{ config, pkgs, lib, ... }:


{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      download-buffer-size = 536870912;
      min-free = 21474836480;
      min-free-check-interval = 5;
      show-trace = true;
      substitute = true;
      fallback = true;
      keep-going = true;
      sandbox = true;
    };
  };
  
  systemd.services.nix-daemon.serviceConfig = {
    Nice = lib.mkForce 15;
    IOSchedulingClass = lib.mkForce "idle";
  };
  
  ### ccache to speed up builds ### https://wiki.nixos.org/wiki/CCache
  programs.ccache = {
    enable = true;
    packageNames = [
      "linuxPackages_latest"
      "linuxPackages_xanmod"
      "linuxPackages_zen"
      "firefox"
      "ungoogled-chromium"
    ];
  };

  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];

  nixpkgs.overlays = [
    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR="${config.programs.ccache.cacheDir}"
          export CCACHE_SLOPPINESS=random_seed # https://github.com/NixOS/nixpkgs/issues/49894#issuecomment-1562664172
          export CCACHE_UMASK=007
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];
}
