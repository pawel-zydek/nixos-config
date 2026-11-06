{ config, lib, pkgs, ... }:
let
  cfg = config.my.programs.wireshark;
in
{
  options.my.programs.wireshark.enable = lib.mkEnableOption "Wireshark z przechwytywaniem bez sudo";

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;     # wersja graficzna (Qt)
    };

    # członkowie tej grupy mogą przechwytywać ruch bez sudo
    users.users.pawel.extraGroups = [ "wireshark" ];
  };
}
