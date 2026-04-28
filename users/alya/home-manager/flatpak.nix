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
      #"flathub:app/org.gnome.Evince/x86_64/stable"
      
      #"flathub:app/com.belmoussaoui.Authenticator/x86_64/stable"
      #"flathub:app/com.belmoussaoui.Decoder/x86_64/stable"
      #"flathub:app/com.github.jeromerobert.pdfarranger/x86_64/stable"
      #"flathub:app/com.github.k4zmu2a.spacecadetpinball/x86_64/stable"
#      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
#      "flathub:app/com.github.wwmm.easyeffects/x86_64/stable"
#      "flathub:app/com.github.xournalpp.xournalpp/x86_64/stable"
#      "flathub:app/com.google.AndroidStudio/x86_64/stable"

      #"flathub:app/com.jeffser.Alpaca/x86_64/stable"
      #"flathub:app/com.jeffser.Alpaca.Plugins.AMD/x86_64/stable"
      #"flathub:app/com.jeffser.Alpaca.Plugins.Ollama/x86_64/stable"

      #"flathub:app/com.obsproject.Studio/x86_64/stable"
      #"flathub:app/com.thincast.client/x86_64/stable"
#      "flathub:app/com.valvesoftware.Steam/x86_64/stable"

#      "flathub:app/dev.lasheen.qr/x86_64/stable"
#      "flathub:app/dev.qwery.AddWater/x86_64/stable"
      #"flathub:app/dev.vencord.Vesktop/x86_64/stable"

      #"flathub:app/io.github.ec_.Quake3e.OpenArena/x86_64/stable"
#      "flathub:app/io.github.quodlibet.QuodLibet/x86_64/stable"
      #"flathub:app/io.github.ungoogled_software.ungoogled_chromium/x86_64/stable"

      #"flathub:app/moe.launcher.sleepy-launcher/x86_64/stable"

      #"flathub:app/net.lutris.Lutris/x86_64/stable"
#      "flathub:app/net.nokyan.Resources/x86_64/stable"

      #"flathub:app/org.blender.Blender/x86_64/stable"
      #"flathub:app/org.darktable.Darktable/x86_64/stable"
      #"flathub:app/org.fedoraproject.MediaWriter/x86_64/stable"
      #"flathub:app/org.freecad.FreeCAD/x86_64/stable"

      #"flathub:app/org.geogebra.GeoGebra/x86_64/stable"
      #"flathub:app/org.gimp.GIMP/x86_64/stable"

#      "flathub:app/org.gnome.Calculator/x86_64/stable"
#      "flathub:app/org.gnome.Calendar/x86_64/stable"
#      "flathub:app/org.gnome.Characters/x86_64/stable"
#      "flathub:app/org.gnome.Chess/x86_64/stable"
#      "flathub:app/org.gnome.Connections/x86_64/stable"
#      "flathub:app/org.gnome.Contacts/x86_64/stable"
#      "flathub:app/org.gnome.Extensions/x86_64/stable"
#      "flathub:app/org.gnome.FileRoller/x86_64/stable"
#      "flathub:app/org.gnome.Firmware/x86_64/stable"
#      "flathub:app/org.gnome.Logs/x86_64/stable"
#      "flathub:app/org.gnome.Loupe/x86_64/stable"
#      "flathub:app/org.gnome.Mahjongg/x86_64/stable"
#      "flathub:app/org.gnome.Maps/x86_64/stable"
#      "flathub:app/org.gnome.Mines/x86_64/stable"
#      "flathub:app/org.gnome.NautilusPreviewer/x86_64/stable"
#      "flathub:app/org.gnome.Quadrapassel/x86_64/stable"
      #"flathub:app/org.gnome.Reversi/x86_64/stable"
#      "flathub:app/org.gnome.SimpleScan/x86_64/stable"
#      "flathub:app/org.gnome.Snapshot/x86_64/stable"
#      "flathub:app/org.gnome.TextEditor/x86_64/stable"
#      "flathub:app/org.gnome.Weather/x86_64/stable"
#      "flathub:app/org.gnome.baobab/x86_64/stable"
#      "flathub:app/org.gnome.clocks/x86_64/stable"
#      "flathub:app/org.gnome.font-viewer/x86_64/stable"

      #"flathub:app/org.kde.kdenlive/x86_64/stable"
      #"flathub:app/org.kde.krita/x86_64/stable"

      #"flathub:app/org.luanti.luanti/x86_64/stable"
      #"flathub:app/org.mozilla.Thunderbird/x86_64/stable"
      #"flathub:app/org.nickvision.tubeconverter/x86_64/stable"
      #"flathub:app/org.octave.Octave/x86_64/stable"
      #"flathub:app/org.onlyoffice.desktopeditors/x86_64/stable"
      #"flathub:app/org.openscad.OpenSCAD/x86_64/stable"
      #"flathub:app/org.prismlauncher.PrismLauncher/x86_64/stable"
      #"flathub:app/org.soundconverter.SoundConverter/x86_64/stable"
      #"flathub:app/org.texstudio.TeXstudio/x86_64/stable"
      #"flathub:app/org.torproject.torbrowser-launcher/x86_64/stable"
#      "flathub:app/org.videolan.VLC/x86_64/stable"

      #"flathub:app/sh.ppy.osu/x86_64/stable"
    ];
  };

}
