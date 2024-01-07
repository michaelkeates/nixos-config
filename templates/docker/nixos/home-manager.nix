# home-manager.nix

{ config, pkgs, lib, ... }:

let
  homeuser = "mike";
  name = "Michael Keates";
  user = "michaelkeates";
  email = "mail@michaelkeates.co.uk";
  xdg_configHome  = "/home/${homeuser}/.config";
in
{
home-manager.users.${homeuser} = {
    enableNixpkgsReleaseCheck = false;
    username = "${homeuser}";
    homeDirectory = "/home/${homeuser}";
    packages = pkgs.callPackage ./packages.nix {};
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
  };

  # Auto mount devices
  services.udiskie.enable = true;
}