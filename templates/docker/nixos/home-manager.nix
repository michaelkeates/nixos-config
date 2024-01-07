{ config, pkgs, lib, ... }:

let
  user = "mike";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    stateVersion = "21.05";
  };

  # Auto mount devices
  services.udiskie.enable = true;

  programs = shared-programs // { gpg.enable = true; };

}