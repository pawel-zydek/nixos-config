{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Boot + ZFS
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  zramSwap.enable = true;

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [ "quiet" "splash" "udev.log_level=3" ];

  # System
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";
  console.keyMap = "pl2";

  # Automatyczne sprzątanie generacji:
  boot.loader.systemd-boot.configurationLimit = 10; # Maksymalna ilość generacji w bootloaderze

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;   # deduplikacja plików w /nix/store

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.xkb.layout = "pl";
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter
    discover
  ];

  # Dźwięk
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Ukrycie partycji ZFS w Dolphinie
  services.udev.extraRules = ''
    ENV{ID_FS_TYPE}=="zfs_member", ENV{UDISKS_IGNORE}="1"
  '';

  # Zakładanie użytkowników
  users.users.pawel = {
    isNormalUser = true;
    description = "Paweł Żydek";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  
  # Zezwolenie na niewolne pakiety
  nixpkgs.config.allowUnfree = true;

  # Dodatkowe pakiety
  environment.systemPackages = with pkgs; [ 
	git 		# Obsługa GITa
	vim 		# Konsolowy edytor tekstu
	mc 		    # Konsolowa przeglądarka plików
	htop		# Konsolowy monitor zasobów
	btop        # Konsolowy monitor zasobów
	nvd         # Porównywanie aktualizacji
	fastfetch   # Informacje o systemie
	kdePackages.kup   # Narzędzia do backupów
	kdePackages.kdeconnect-kde  # KDE Connect - Plasma sama uruchamia go przy logowaniu
	bitwarden-desktop # Menadżer haseł - dla współpracy z PAM
	# Miejsce na kolejne aplikacje
	# Ustawienie tła SDDM
	(writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    type=image
    background=${../home/Wallpapers/NixOS/NixOS-Stripes-Logo.png}
    '')
  ];

  # Zarządzanie partycjami
  programs.partition-manager.enable = true;

  # Snapshoty ZFS
  services.sanoid = {
    enable = true;
    templates.default = { hourly = 24; daily = 7; monthly = 3; autosnap = true; autoprune = true; };
    datasets."rpool/home".useTemplate = [ "default" ];
  };

  # Wersja systemu na jakiej pierwotnie zainstalowano NixOS
  system.stateVersion = "26.05";
}
