{ ... }:
{
  imports = [
    ./git.nix           # Konfiguracja gita
    ./vim.nix           # Konfiguracja vima
    ./firefox.nix       # Instalacja i konfiguracja Firefoxa
    ./thunderbird.nix   # Instalacja i konfiguracja Thunderbirda
    ./plasma.nix        # Konfiguracja wyglądu KDE
    ./packages.nix      # Dodatkowe pakiety
    ./virt.nix          # Koniguracja Virt Managera
    ./kdeconnect.nix    # Zainstalowanie KDE Conncect
  ];

  # wersja z pierwszego wdrożenia; nie zmieniamy przy aktualizacjach
  home.stateVersion = "26.05";
}
