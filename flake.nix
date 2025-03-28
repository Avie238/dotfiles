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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      apple-silicon,
      nix-vscode-extensions,
    }@inputs:
    let
      system = "aarch64-linux";
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        avie-nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/hosts/asahi
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.avie = import ./home-manger/users/avie;
            }
          ];
          specialArgs = { inherit inputs self; };
        };
      };

    };
}
