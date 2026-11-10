{ config, lib, pkgs, ... }:
let
  cfg = config.my.desktop.plasma;
in
{
  options.my.desktop.plasma.enable = lib.mkEnableOption "KDE Plasma 6 z SDDM";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      khelpcenter
      discover
    ];

    # Zarządzanie partycjami (KDE Partition Manager)
    programs.partition-manager.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.kup             # kopie zapasowe (Ustawienia systemowe -> Kopie zapasowe)
      bup                         # silnik kopii wersjonowanych Kup
      rsync                       # silnik kopii synchronizowanych Kup
      kdePackages.kdeconnect-kde  # KDE Connect - Plasma sama uruchamia go przy logowaniu

      # Tło SDDM
      (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        type=image
        background=${../../../assets/wallpapers/NixOS/NixOS-Stripes-Logo.png}
      '')
    ];
  };
}
