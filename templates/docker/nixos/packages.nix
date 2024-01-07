{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages ++ [

  # Security and authentication
  bitwarden

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager
]