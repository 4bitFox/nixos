{ config, pkgs, lib, ... }:


{
  home = {
    packages = with pkgs; [
      brightnessctl
      mako
      fuzzel
      #swww
      wbg
      hyprlock
      libnotify
      alacritty
      nautilus
      networkmanagerapplet
      pavucontrol
      pasystray
      wev
      file-roller
      gnome-text-editor
      seahorse
      eog
      papers
      gnome-calculator
      vlc
      resources
    ];
    
    file = {
      ".config/niri/config.kdl" = {
        source = ./homefiles/.config/niri/config.kdl;
      };
      ".config/niri/audio-volume.bash" = {
        source = ./homefiles/.config/niri/audio-volume.bash;
        executable = true;
      };
      ".config/niri/battery-low-warning.bash" = {
        source = ./homefiles/.config/niri/battery-low-warning.bash;
        executable = true;
      };
      ".config/niri/screen-brightness.bash" = {
        source = ./homefiles/.config/niri/screen-brightness.bash;
        executable = true;
      };
      ".config/niri/qs-notification.bash" = {
        source = ./homefiles/.config/niri/qs-notification.bash;
        executable = true;
      };
    };
  };
}
