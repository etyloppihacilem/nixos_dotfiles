{
  description = "General flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvim-config.url = "git+/home/sherlock/.config/nvim";
    nvim-config.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nvf,
    ...
  } @inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sherlock = {
	    imports = [
	      ./home.nix
	      nvf.homeManagerModules.default
	    ];
          };
          home-manager.extraSpecialArgs = {inherit inputs;};
        }
      ];
    };
  };
}
