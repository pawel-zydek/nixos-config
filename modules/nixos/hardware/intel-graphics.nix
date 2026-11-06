{ config, lib, pkgs, ... }:
let
  cfg = config.my.hardware.intelGraphics;
in
{
  options.my.hardware.intelGraphics.enable = lib.mkEnableOption "sprzętowe dekodowanie wideo na grafice Intel";

  config = lib.mkIf cfg.enable {
    # Sprzętowe dekodowanie wideo (VA-API) w Firefoksie, VLC itp.
    # intel-media-driver obsługuje Broadwell (2014) i nowsze
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt                 # Quick Sync (kodowanie wideo), 11. gen. i nowsze
    ];
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };
}
