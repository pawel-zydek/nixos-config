{ pkgs, ... }:
{
  # instaluje gnupg i zarządza plikami konfiguracyjnymi w ~/.gnupg
  programs.gpg.enable = true;

  # agent GPG z okienkiem na hasło w wersji Qt
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 1800;     # sekundy: jak długo agent pamięta hasło po użyciu
    maxCacheTtl = 7200;         # maksymalny czas pamiętania
  };

  home.packages = with pkgs; [
    kdePackages.kleopatra
    paperkey                    # wydruk klucza tajnego
  ];
}
