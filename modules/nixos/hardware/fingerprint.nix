{ config, lib, ... }:
let
  cfg = config.my.hardware.fingerprint;
in
{
  options.my.hardware.fingerprint.enable = lib.mkEnableOption "czytnik linii papilarnych (fprintd)";

  config = lib.mkIf cfg.enable {
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
  };
}
