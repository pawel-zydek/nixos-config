{ config, lib, ... }:
let
  cfg = config.my.services.printing;
in
{
  options.my.services.printing.enable = lib.mkEnableOption "drukowanie i wykrywanie drukarek w sieci";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
