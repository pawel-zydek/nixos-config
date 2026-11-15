# Steam jest instalowany w systemie (nie HomeManager) ponieważ obsługa dodaje dodatkowe wymagania, a nie samego klienta
{ config, lib, pkgs, ... }:
let
  cfg = config.my.programs.steam;
in
{
  options.my.programs.steam.enable = lib.mkEnableOption "Steam dla Linuxa";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
    environment.systemPackages = [ pkgs.mangohud ];
  };
}
