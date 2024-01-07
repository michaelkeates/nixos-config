# home-manager.nix

{ config, pkgs, ... }:

let
  homeuser = "mike";
  
  # Importing the shared packages from packages.nix
  shared-packages = import ./packages.nix { inherit pkgs; };
in
{
  home-manager.users.${homeuser} = {
    enable = true;
    packages = shared-packages;
  };

  # Auto mount devices
  services.udiskie.enable = true;
}