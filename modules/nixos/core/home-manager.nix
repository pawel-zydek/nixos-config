{ config, inputs, ... }:
{
  # Home Manager jako moduł NixOS - konfiguracja użytkownika jest częścią generacji
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    overwriteBackup = true;     # stary plik .bak nie blokuje aktywacji przy kolejnej kolizji
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    # plik users/<login>.nix wybiera moduły z modules/home/
    users.${config.my.user} = import (../../../users + "/${config.my.user}.nix");
  };
}
