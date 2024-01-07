{ pkgs }:

[
  # General packages for development and system management
  pkgs.docker
  pkgs.docker-compose

  # App and package management
  pkgs.appimage-run
  pkgs.gnumake
  pkgs.cmake
  pkgs.home-manager
]