{ config, lib, ... }:
let
  cfg = config.my.hardware.fingerprint;
in
{
  options.my.hardware.fingerprint.enable = lib.mkEnableOption "czytnik linii papilarnych (fprintd)";

  config = lib.mkIf cfg.enable {
    services.fprintd.enable = true;

    # Logowanie (SDDM i konsola) tylko hasłem: odcisk nie odblokowuje KWallet,
    # a pam_fprintd czeka ~30 s na palec, zanim sprawdzi hasło.
    # Uwaga: SDDM korzysta z reguł usługi "login", więc wyłączamy ją tutaj.
    security.pam.services.login.fprintAuth = false;
  };
}
