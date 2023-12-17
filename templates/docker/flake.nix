{
  description = "Starter Configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:dustinlyons/nixpkgs/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko } @inputs:
    let
      user = "mike";
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      devShell = system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };
    in
    {

      devShells = forAllSystems devShell;

      nixosConfigurations = let user = "mike"; in {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [
            ./nixos
            disko.nixosModules.disko
          ];
        };
      };
  };
}
