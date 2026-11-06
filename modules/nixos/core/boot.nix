{ ... }:
{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;   # maksymalna liczba generacji w menu
  boot.loader.efi.canTouchEfiVariables = true;

  # Plymouth i cichy start
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" "splash" "udev.log_level=3" ];

  # Swap w RAM (bez partycji swap)
  zramSwap.enable = true;
}
