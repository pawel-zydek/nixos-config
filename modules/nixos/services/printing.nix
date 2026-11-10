{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.printing;
in
{
  options.my.services.printing.enable = lib.mkEnableOption "drukowanie i skanowanie (CUPS, Epson, SANE) z wykrywaniem urządzeń w sieci";

  config = lib.mkIf cfg.enable {
    # Druk
    services.printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
    };

    # Wykrywanie drukarki i skanera w sieci (mDNS)
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      # Domyślnie Avahi otwiera UDP 5353 na WSZYSTKICH interfejsach (także br100/br200).
      # Port otwiera host tylko tam, gdzie trzeba - patrz hosts/pg/network.nix.
      openFirewall = false;
    };

    # Skaner
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    services.udev.packages = [ pkgs.sane-airscan ];

    users.users.${config.my.user}.extraGroups = [ "scanner" "lp" ];

    # Program do skanowania
    environment.systemPackages = [ pkgs.kdePackages.skanpage ];
  };
}
