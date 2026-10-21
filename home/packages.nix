{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc                           # Odtwarzacz multimedialny
    obsidian                      # Aplkacja do notatek w MD
    libreoffice-qt6               # Pakiet biurowy
    kdePackages.krdc              # Aplkacja do RDP i VNC
    bitwarden-desktop             # Manadżer haseł
    anki                          # Program do fiszek
    kdePackages.k3b               # Nagrywanie CD
    kdePackages.audex             # Rippowanie CD
    spotify                       # Klient Spotify
    kdePackages.arianna           # Czytnik ebooków
    kdePackages.filelight         # Monitorowanie zużycia dysku
    kdePackages.kcalc             # Kalkulator
    kdePackages.partitionmanager  # Zarządzanie partycjami
    kdePackages.kfind             # Wyszukiwanie plików
    kdePackages.isoimagewriter    # Zapisywanie obrazów ISO
    kdePackages.kleopatra         # Zarządzanie szyfrowaniem
    kid3-kde                      # Edytor tagów plików dźwiękowych
    kdePackages.kasts             # Słuchanie podcastów
    kdePackages.kup               # Narzędzia do backupów
  ];
}
