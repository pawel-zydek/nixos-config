# Gry: Steam i Heroic (GOG/Epic/Amazon).
# Instalowane w systemie (nie HomeManager), ponieważ obsługa wymaga dodatkowych
# ustawień systemowych (grafika 32-bit, firewall, gamemode), a nie samych klientów.
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.programs.gaming;
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.my.programs.gaming.enable = lib.mkEnableOption "Gry: Steam i Heroic Games Launcher";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
    environment.systemPackages = [
      pkgs.mangohud
      # Launcher dla GOG, Epic i Amazon. Z unstable, bo logowanie do GOG
      # (blokada Cloudflare) naprawiono dopiero w wersji 2.22.4.
      unstable.heroic
    ];
  };
}
