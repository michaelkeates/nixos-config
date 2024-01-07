{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages ++ [

  # General packages for development and system management
  docker
  docker-compose

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager
]