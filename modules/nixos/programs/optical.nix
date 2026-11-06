{ config, lib, pkgs, ... }:
let
  cfg = config.my.programs.optical;
in
{
  options.my.programs.optical.enable = lib.mkEnableOption "napęd optyczny: K3b, rippowanie CD";

  config = lib.mkIf cfg.enable {
    programs.k3b.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.audex      # rippowanie CD
      cdparanoia             # odczyt płyt audio
    ];

    users.users.pawel.extraGroups = [ "cdrom" ];

    # dostęp do napędu optycznego dla grupy cdrom
    services.udev.extraRules = ''
      KERNEL=="sr[0-9]*", GROUP="cdrom", MODE="0660"
    '';
  };
}
