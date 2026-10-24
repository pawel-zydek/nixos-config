{ pkgs, ... }:
{
  # Firmware (m.in. karta Wi-Fi Intel, mikrokod CPU)
  hardware.enableRedistributableFirmware = true;

  # Grafika Intel: sprzętowe dekodowanie wideo (VA-API) w Firefoksie, VLC itp.
  # intel-media-driver obsługuje Broadwell (2014) i nowsze
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt                 # Quick Sync (kodowanie wideo), 11. gen. i nowsze
  ];
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # Czytnik linii papilarnych
  services.fprintd.enable = true;
  # Jeśli czytnika nie ma na liście libfprint, potrzebny jest sterownik TOD, np.:
  # services.fprintd.tod = {
  #   enable = true;
  #   driver = pkgs.libfprint-2-tod1-goodix;   # dobrać do `lsusb`
  # };
  # Logowanie (SDDM i konsola) tylko hasłem: odcisk nie odblokowuje KWallet,
  # a pam_fprintd czeka ~30 s na palec, zanim sprawdzi hasło.
  # Uwaga: SDDM korzysta z reguł usługi "login", więc wyłączamy ją tutaj.
  # Odcisk dalej działa w sudo i na ekranie blokady (usługa kde-fingerprint).
  security.pam.services.login.fprintAuth = false;

  # Bluetooth (słuchawki, myszka); Plasma dostarcza applet
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Aktualizacje firmware/BIOS z poziomu systemu (Discover jest wyłączony):
  #   fwupdmgr refresh && fwupdmgr update
  services.fwupd.enable = true;

  # Drukowanie i wykrywanie drukarek w sieci
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
