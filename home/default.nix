{ ... }:
{
  imports = [
    ./git.nix
    ./vim.nix
    ./firefox.nix
    ./plasma.nix
  ];

  # wersja z pierwszego wdrożenia; nie zmieniamy przy aktualizacjach
  home.stateVersion = "26.05";
}
