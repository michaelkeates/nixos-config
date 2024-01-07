# home-manager.nix

{ config, pkgs, ... }:

{
  home-manager.users.mike = {
    enable = true;
    packages = import ./packages.nix { inherit pkgs; };
  };

  # Auto mount devices
  services.udiskie.enable = true;
}
