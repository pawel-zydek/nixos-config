{ pkgs, ... }:
{
  # Pakiety systemowe (programy użytkownika są w modules/home/packages.nix)
  environment.systemPackages = with pkgs; [
    git               # obsługa gita
    vim               # konsolowy edytor tekstu
    mc                # konsolowa przeglądarka plików
    htop              # konsolowy monitor zasobów
    btop              # konsolowy monitor zasobów
    nvd               # porównywanie aktualizacji
    fastfetch         # informacje o systemie
    smartmontools     # kontrola dysku
    bitwarden-desktop # menadżer haseł - dla współpracy z PAM
  ];
}
