{ ... }:
{
  imports = [
    ./git.nix
    ./vim.nix
    ./firefox.nix
    ./thunderbird.nix
    ./plasma.nix
    ./packages.nix
    ./virt.nix
  ];

  # wersja z pierwszego wdrożenia; nie zmieniamy przy aktualizacjach
  home.stateVersion = "26.05";
}
