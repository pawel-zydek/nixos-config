{ config, lib, ... }:
let
  cfg = config.my.hardware.bluetooth;
in
{
  options.my.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf cfg.enable {
    # Słuchawki, myszka; Plasma dostarcza applet
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
