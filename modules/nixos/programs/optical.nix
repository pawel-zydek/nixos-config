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

    users.users.${config.my.user}.extraGroups = [ "cdrom" ];

    # /dev/sr* dostaje grupę cdrom i tryb 0660 z domyślnych reguł udev (50-udev-default.rules)
  };
}
