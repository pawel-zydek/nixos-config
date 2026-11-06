{ ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatyczne sprzątanie starych generacji i /nix/store
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;   # deduplikacja plików w /nix/store

  # Zezwolenie na niewolne pakiety
  nixpkgs.config.allowUnfree = true;
}
