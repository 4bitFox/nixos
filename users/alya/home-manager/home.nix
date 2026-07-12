{ config, pkgs, lib, ... }:

let
  ### force violet folders for papirus icon theme ###
  papirus-icon-theme_violet = pkgs.papirus-icon-theme.overrideAttrs (old: {
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
  
in

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
    ./hyprpolkitagent.nix
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
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      kdePackages.qt6ct
      fastfetch
      gnome-software
    ];
    
    pointerCursor = {
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
  
  ### GTK theme ###
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus-icon-theme_violet;
    };
    gtk4.theme = config.gtk.theme; # keep legacy behavior from 25.11; The default value of `gtk.gtk4.theme` has changed from `config.gtk.theme` to `null`.
  };
  
  home.file = {
    ".local/share/icons/Papirus-Violet".source = "${papirus-icon-theme_violet}/share/icons/Papirus";
    ".icons/Papirus-Violet".source = "${papirus-icon-theme_violet}/share/icons/Papirus";
    ".local/share/doublecmd/pixmaps/Papirus-Violet".source = "${papirus-icon-theme_violet}/share/icons/Papirus";
  };
  ### GTK theme (end) ###
  
  ### kvantunm theme ###
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style = {
      name = "kvantum";
      package = pkgs.rose-pine-kvantum;
    };
  };
  
  xdg.dataFile."Kvantum/rose-pine-moon-iris".source =
    "${pkgs.rose-pine-kvantum}/share/Kvantum/themes/rose-pine-moon-iris";

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=rose-pine-moon-iris
  '';
  ### kvantum theme (end) ###

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  xdg.autostart.enable = false;
  systemd.user.generators = {
    "systemd-xdg-autostart-generator" = {
      source = "/dev/null";
    };
  };

  home.stateVersion = "25.11";
}
