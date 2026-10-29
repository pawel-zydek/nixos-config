{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc                           # Odtwarzacz multimedialny
    obsidian                      # Aplkacja do notatek w MD
    libreoffice-qt6               # Pakiet biurowy
    kdePackages.krdc              # Aplkacja do RDP i VNC
    anki-bin                      # Program do fiszek
    lame flac vorbis-tools opus-tools   # kodery MP3, FLAC, Ogg
    spotify                       # Klient Spotify
    keepassxc
    kdePackages.arianna           # Czytnik ebooków
    kdePackages.filelight         # Monitorowanie zużycia dysku
    kdePackages.kcalc             # Kalkulator
    kdePackages.kfind             # Wyszukiwanie plików
    kdePackages.isoimagewriter    # Zapisywanie obrazów ISO
    kid3-kde                      # Edytor tagów plików dźwiękowych
    kdePackages.kasts             # Słuchanie podcastów
    drawio                        # Tworzenie diagramów i schematów
  ];
}
