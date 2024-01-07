{ config, pkgs, lib, ... }:

let
  homeuser = "mike";
  name = "Michael Keates";
  email = "mail@michaelkeates.co.uk";
  xdg_configHome  = "/home/${homeuser}/.config";
in
{
  home-manager.users.${homeuser} = {
    enable = true;
    home.file.".bashrc".text = ''
      export EDITOR=vim
    '';

    packages = with pkgs; [
        # General packages for development and system management
        docker
        docker-compose
        git
        gh

        # App and package management
        appimage-run
        gnumake
        cmake
        home-manager
    ];

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
