{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc               # Odtwarzacz multimedialny
    obsidian          # Aplkacja do notatek w MD
    libreoffice-qt6   # Pakiet biurowy
    kdePackages.krdc  # Aplkacja do RDP i VNC
    bitwarden-desktop # Manadżer haseł
    anki              # Program do fiszek
    kdePackages.k3b   # Nagrywanie CD
    kdePackages.audex # Rippowanie CD
  ];
}
