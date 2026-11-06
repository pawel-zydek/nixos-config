{ inputs, ... }:
{
  # Home Manager jako moduł NixOS - konfiguracja użytkownika jest częścią generacji
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    users.pawel = import ../../../users/pawel.nix;
  };
}
