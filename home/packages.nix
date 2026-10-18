{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    obsidian
    libreoffice-qt6
  ];
}
