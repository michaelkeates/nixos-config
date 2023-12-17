{ config, pkgs, ... }:

let
  user = "mike";
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2s50ZOnMkQVFIPmgfcMFt8VlwXYQ4ek4wyNtAAeouO" ];
in {
  imports = [
    ./disk-config.nix
  ];

  home-manager.users.${user} = {
   home = {
      homeDirectory = lib.mkForce "/home/${user}";
   };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings.allowed-users = [ "${user}" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.gnupg.agent.enable = true;
  services.openssh.enable = true;
  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
    enableNvidia = false;
  };

  system.stateVersion = "21.05";
}