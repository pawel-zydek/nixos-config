{ pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;     # wersja graficzna (Qt)
  };

  # członkowie tej grupy mogą przechwytywać ruch bez sudo
  users.users.pawel.extraGroups = [ "wireshark" ];
}
