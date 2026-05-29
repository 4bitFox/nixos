{ config, pkgs, lib, declarative-flatpak, ... }:


{
  imports = [
    declarative-flatpak.homeModules.default
  ];


  services.flatpak = {
    remotes = {
      flathub = "https://flathub.org/repo/flathub.flatpakrepo";
    };

    packages = [
      "flathub:app/org.spyder_ide.spyder/x86_64/stable"
      "flathub:app/moe.launcher.the-honkers-railway-launcher/x86_64/stable"
      "flathub:app/moe.launcher.an-anime-game-launcher/x86_64/stable"
      "flathub:app/us.zoom.Zoom/x86_64/stable"
      
      "flathub:app/com.belmoussaoui.Authenticator/x86_64/stable"
      "flathub:app/com.belmoussaoui.Decoder/x86_64/stable"
      "flathub:app/com.github.jeromerobert.pdfarranger/x86_64/stable"
      "flathub:app/com.github.k4zmu2a.spacecadetpinball/x86_64/stable"
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
#      "flathub:app/com.google.AndroidStudio/x86_64/stable"


      "flathub:app/com.obsproject.Studio/x86_64/stable"
      "flathub:app/com.thincast.client/x86_64/stable"

#      "flathub:app/dev.lasheen.qr/x86_64/stable"
      "flathub:app/dev.vencord.Vesktop/x86_64/stable"

      "flathub:app/io.github.ec_.Quake3e.OpenArena/x86_64/stable"

      "flathub:app/moe.launcher.sleepy-launcher/x86_64/stable"


      # "flathub:app/org.blender.Blender/x86_64/stable"
      "flathub:app/org.darktable.Darktable/x86_64/stable"
      "flathub:app/org.fedoraproject.MediaWriter/x86_64/stable"
      "flathub:app/org.freecad.FreeCAD/x86_64/stable"

      "flathub:app/org.geogebra.GeoGebra/x86_64/stable"
      # "flathub:app/org.gimp.GIMP/x86_64/stable"

      "flathub:app/org.gnome.Chess/x86_64/stable"
      "flathub:app/org.gnome.Mahjongg/x86_64/stable"
      "flathub:app/org.gnome.Mines/x86_64/stable"
      "flathub:app/org.gnome.Quadrapassel/x86_64/stable"
      "flathub:app/org.gnome.Reversi/x86_64/stable"

      # "flathub:app/org.kde.kdenlive/x86_64/stable"
      # "flathub:app/org.kde.krita/x86_64/stable"

      "flathub:app/org.luanti.luanti/x86_64/stable"
      #"flathub:app/org.mozilla.Thunderbird/x86_64/stable"
      "flathub:app/org.nickvision.tubeconverter/x86_64/stable"
      "flathub:app/org.openscad.OpenSCAD/x86_64/stable"
      "flathub:app/org.prismlauncher.PrismLauncher/x86_64/stable"
      "flathub:app/org.soundconverter.SoundConverter/x86_64/stable"
      "flathub:app/org.torproject.torbrowser-launcher/x86_64/stable"

      "flathub:app/sh.ppy.osu/x86_64/stable"
      "flathub:app/com.usebottles.bottles/x86_64/stable"
      "flathub:app/io.seamly.seamly2d/x86_64/stable"
    ];
  };

}
