{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc               # Odtwarzacz multimedialny
    obsidian          # Aplkacja do notatek w MD
    libreoffice-qt6   # Pakiet biurowy
    kdePackages.krdc  # Aplkacja do RDP i VNC
  ];
}
