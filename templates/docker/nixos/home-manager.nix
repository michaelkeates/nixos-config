{ config, pkgs, lib, ... }:

let
  homeuser = "mike";
  name = "Michael Keates";
  email = "mail@michaelkeates.co.uk";
  xdg_configHome = "/home/${homeuser}/.config";

  # Importing the shared packages from packages.nix
  shared-packages = import ./packages.nix { inherit pkgs; };
in
{
  home-manager.users.${homeuser} = {
    enable = true;

    stateVersion = "23.11";
    git = {
      enable = true;
      ignores = [ "*.swp" ];
      userName = name;
      userEmail = email;
      lfs = {
        enable = true;
      };
    };

    # Adding the shared packages to the user configuration
    packages = shared-packages;
  };

  # Auto mount devices
  services.udiskie.enable = true;
}