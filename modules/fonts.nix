
{ config, pkgs, lib, ... }:


{
  console = {
    font = "latarcyrheb-sun32";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.dejavu-sans-mono
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      nerd-fonts.noto
      liberation_ttf
      nerd-fonts.liberation
      corefonts
      vista-fonts
      vista-fonts-chs
      vista-fonts-cht
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "DejaVu Serif" "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "DejaVu Sans" "Noto Sans" "Liberation Sans" ];
        monospace = [ "DejaVuSansM Nerd Font" "NotoMono NF" "LiberationMono Nerd Font" ];
        emoji = ["Noto Color Emoji" "Noto Emoji"];
      };
      useEmbeddedBitmaps = true;
    };
  fontDir.enable = true;
  };
}
