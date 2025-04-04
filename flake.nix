{
  description = "Asahi linux Nixos M2 air";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    apple-silicon = {
      url = "github:Avie238/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      apple-silicon,
      nix-vscode-extensions,
      sops-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        avie-nixos = lib.nixosSystem {
          modules = [
            ./hosts/asahi
            home-manager.nixosModules.home-manager
            self.nixosModules.declarativeHome
            self.nixosModules.users-avie
          ];
          specialArgs = { inherit inputs self; };
        };

        msi-nixos = lib.nixosSystem {
          modules = [
            ./hosts/msi
            home-manager.nixosModules.home-manager
            self.nixosModules.declarativeHome
            self.nixosModules.users-avie
            inputs.disko.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
          ];
          specialArgs = { inherit inputs self; };
        };

        x86-iso = lib.nixosSystem {
          modules = [
            ./hosts/x86-iso
          ];
          specialArgs = { inherit inputs self; };
        };
      };

      nixosModules = {
        declarativeHome = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };

        users-avie = {
          home-manager.users.avie = ./home-manger/users/avie;
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];
        };

      };

    };
}
