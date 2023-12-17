{
  description = "Mike's Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:dustinlyons/nixpkgs/master";
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/michaelkeates/nix-secrets.git";
      flake = false;
    };
  };

  outputs = { self, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, home-manager, nixpkgs, disko, agenix, secrets } @inputs:
    let
      user = "mike";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" ];
      forAllLinuxSystems = f: nixpkgs.lib.genAttrs linuxSystems (system: f system);
      forAllDarwinSystems = f: nixpkgs.lib.genAttrs darwinSystems (system: f system);
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) (system: f system);
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in
        pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive pkgs.git pkgs.age pkgs.age-plugin-yubikey ];
          shellHook = ''
            export EDITOR=vim
          '';
        };
      mkApp = scriptName: template: system:
        nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system} with template ${template}"
          exec ${self}/apps/${system}/${template}/${scriptName}
        '';
      mkApps = system: template: {
        "install" = mkApp "install" template system;
        "rebuild" = mkApp "rebuild" template system;
        "copyKeys" = mkApp "copyKeys" "default" system;
        "createKeys" = mkApp "createKeys" "default" system;
        "checkKeys" = mkApp "checkKeys" "default" system;
      };
    in
    {
      templates = {
        default = {
          path = ./templates/default;
          description = "Starter configuration";
        };
        docker = {
          path = ./templates/docker;
          description = "Docker Server";
        };
      };
      devShells = forAllSystems devShell;

      apps = nixpkgs.lib.genAttrs linuxSystems (system: nixpkgs.lib.genAttrs (templates: mkApps system templates) (self.templates)) // 
             nixpkgs.lib.genAttrs darwinSystems (system: nixpkgs.lib.genAttrs (templates: mkApps system templates) (self.templates));

      darwinConfigurations = let user = "mike"; in
        {
          "Mikes-MBA" = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = inputs;
            modules = [
              home-manager.darwinModules.home-manager
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  user = "${user}";
                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                    "homebrew/bundle" = homebrew-bundle;
                  };
                  mutableTaps = false;
                  autoMigrate = true;
                };
              }
              ./darwin
            ];
          };
        };
      
      nixosConfigurations = forAllSystems (system: templates: nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = inputs;
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./nixos/home-manager.nix;
          }
          ./nixos
        ];
      } templates);
    };
}
