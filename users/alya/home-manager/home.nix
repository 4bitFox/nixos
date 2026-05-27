{ config, pkgs, lib, ... }:


{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./fuzzel.nix
    ./view-screencast.nix
    ./fastfetch.nix
    ./alacritty.nix
    ./mako.nix
    ./hyprlock.nix
    ./flatpak.nix
    ./dotfiles.nix
    ./homefiles.nix
    ./packages.nix
  ];

  home = {
    username = "alya";
    homeDirectory = "/home/alya";

    packages = with pkgs; [
      gnome-themes-extra
      adw-gtk3
      fastfetch
      gnome-software
    ];
    pointerCursor = {
      # name = "catppuccin-latte-mauve-cursors";
      # package = pkgs.catppuccin-cursors.latteMauve;
      name = "phinger-cursors-dark-left";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      initExtra = ''
        fastfetch
      '';
    };
  };
  
  services = {
    mpris-proxy.enable = true;
  };
  
  gtk = {
    enable = true;
    theme = {
      # name = "Adwaita-dark";
      # package = pkgs.gnome-themes-extra;
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      ### force violet folders for papirus icon theme ###
      package = pkgs.papirus-icon-theme.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          echo "MANUAL OVERRIDE: Forcing violet folder icons! ~~~ pretty :D"
          themeDir="$out/share/icons/Papirus"
          sizeDirs=(22x22 24x24 32x32 48x48 64x64)
          for size in "''${sizeDirs[@]}"; do
            for f in "$themeDir/$size/places"/folder-violet*.svg; do
              [ -e "$f" ] || continue
              ln -sf "$(basename "$f")" "$themeDir/$size/places/folder.svg"
            done
          done
          echo "MANUAL OVERRIDE OVER: Violet folders all nice and done! ... hopefully ^^"
        '';
      });
      ### force violet folders for papirus icon theme (end) ###
    };
  };
  
  qt = {
    enable = true;
    platformTheme = "gnome";
    # style.name = "kvantum";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.stateVersion = "25.11";
}
