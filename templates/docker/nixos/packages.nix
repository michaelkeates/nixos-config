
{ pkgs }:

[
  # General packages for development and system management
  pkgs.docker
  pkgs.docker-compose
  pkgs.git
  pkgs.gh

  # App and package management
  pkgs.appimage-run
  pkgs.gnumake
  pkgs.cmake
  pkgs.home-manager
]
