{ config, pkgs, ... }:

let
  user = "mike";
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2s50ZOnMkQVFIPmgfcMFt8VlwXYQ4ek4wyNtAAeouO" ];
in {
  imports = [
    ./disk-config.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # make sure to include modules, these are needed for VMs to work
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
