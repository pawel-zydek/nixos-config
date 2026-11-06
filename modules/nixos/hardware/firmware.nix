{ config, lib, ... }:
let
  cfg = config.my.hardware.firmware;
in
{
  options.my.hardware.firmware.enable = lib.mkEnableOption "firmware urządzeń i aktualizacje BIOS/UEFI (fwupd)";

  config = lib.mkIf cfg.enable {
    # Firmware (m.in. karta Wi-Fi Intel, mikrokod CPU)
    hardware.enableRedistributableFirmware = true;

    # Aktualizacje firmware/BIOS z poziomu systemu (Discover jest wyłączony):
    #   fwupdmgr refresh && fwupdmgr update
    services.fwupd.enable = true;
  };
}
