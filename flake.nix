{
  description = "Konfiguracja NixOS laptopa (host nixos-pg)";

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

  outputs = { nixpkgs, ... }@inputs: {
    # Lista hostów. Cała logika jest w hosts/ i modules/.
    # Nazwa = hostname, więc `sudo nixos-rebuild switch --flake .` sam wybiera właściwy host.
    nixosConfigurations = {
      nixos-pg = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };   # `inputs` dostępne w każdym module
        modules = [ ./hosts/pg ];
      };
    };

    # `nix fmt` - formatowanie wszystkich plików .nix w repo
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
  };
}
