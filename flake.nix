{
  description = "Moje konfiguracje NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, plasma-manager, ... }:
  let
    # ustawienia Home Managera wspólne dla wszystkich hostów
    homeModule = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        sharedModules = [ plasma-manager.homeModules.plasma-manager ];
        users.pawel = import ./home;
      };
    };
  in {
    nixosConfigurations = {
      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          homeModule
          ./modules/common.nix
          ./modules/disko-zfs.nix
          ./hosts/vm
        ];
      };
      pg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          homeModule
          ./modules/common.nix
          ./modules/disko-zfs.nix
          ./hosts/pg
        ];
      };
    };
  };
}
