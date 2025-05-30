{ config, inputs, pkgs, agenix, ... }:

let
  user = "mike";
  keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2s50ZOnMkQVFIPmgfcMFt8VlwXYQ4ek4wyNtAAeouO" ];
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.permittedInsecurePackages = [
  #  "mailspring-1.12.0"
  #];
in
{
  imports = [
    ./secrets.nix
    ./disk-config.nix
    ../shared
    ../shared/cachix
    agenix.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.configurationLimit = 42;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # make sure to include modules, these are needed for VMs to work
  # boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.blacklistedKernelModules = [ "rtl8xxxu" ];
  #boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8192eu ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.rtl8761b-firmware ];
  #hardware.firmware = [ pkgs.rtl8761b-firmware ];

  # Enable bluetooth
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual"; 
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = "nixos"; # Define your hostname.
  #networking.useDHCP = false;
  #networking.interfaces.eno1.useDHCP = true;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 7000 7001 7100 ];
  networking.firewall.allowedUDPPorts = [ 5353 6000 6001 7011 ];

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
      domain = true;
    };
  };

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings.allowed-users = [ "${user}" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # Manages keys and such
  programs.gnupg.agent.enable = true;

  # Needed for anything GTK related
  programs.dconf.enable = true;

  services.xserver.enable = true;

  # Uncomment these for AMD GPU
  # boot.initrd.kernelModules = [ "amdgpu" ];
  # services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  # Comment this for AMD GPU
  # This helps fix tearing of windows for Nvidia cards
  services.xserver.screenSection = ''
    Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option       "AllowIndirectGLXProtocol" "off"
    Option       "TripleBuffer" "on"
  '';

  # LightDM Display Manager
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.defaultSession = "hyprland";
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.lightdm = {
  # enable = true;
  # greeters.slick.enable = true;
  # background = ./config/login-wallpaper.jpg;
  #};

  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "${(pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "kde-plasma-chili";
    rev = "a371123959676f608f01421398f7400a2f01ae06";
    sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
  })}";
  };

  # Tiling window manager
  services.xserver.windowManager.bspwm = {
    enable = true;
    configFile = ./config/bspwmrc;
    sxhkd.configFile = ./config/sxhkdrc;
  };

  #programs.hyprland = {
  #  enable = true;
  #  xwayland.enable = true;
  #};

  # Hint Electon apps to use wayland
  #environment.sessionVariables = {
  #  NIXOS_OZONE_WL = "1";
  # };

  # Turn Caps Lock into Ctrl
  # services.xserver.layout = "uk";
  # services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ]; # Brother printer driver

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Video support
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;
  hardware.nvidia.modesetting.enable = true;

  # Enable Xbox support
  # hardware.xone.enable = true;

  # Crypto wallet support
  #hardware.ledger.enable = true;

  # Enable gnome-keyring daemon
  services.gnome.gnome-keyring.enable = true;

  # Better support for general peripheralss
  services.xserver.libinput.enable = true;
  boot.kernelModules = [ "uinput" "btintel" "btqca" "btusb" "hci_qca" "hci_uart" ];

  # Sync state between machines
  #services.syncthing = {
  #  enable = true;
  #  openDefaultPorts = true;
  #  dataDir = "/home/${user}/.local/share/syncthing";
  #  configDir = "/home/${user}/.config/syncthing";
  #  user = "${user}";
  #  group = "users";
  #  guiAddress = "127.0.0.1:8384";
  #  overrideFolders = true;
  #  overrideDevices = true;

   # settings.devices = {
   #   "Macbook Pro" = {
   #     id = "P2FYLQW-PKDFJGZ-EUGI2T7-OW4AH4I-KI462HD-U2VL3X3-GN55PP2-VNRE5AH";
   #     autoAcceptFolders = true;
   #     allowedNetwork = "192.168.0.0/16";
   #     addresses = [ "tcp://192.168.0.99:51820" ];
   #   };
   #   "Home Lab" = {
   #     id = "WW5O366-THBBBA3-HKQAYCP-EWADS4I-4KDDC5Z-3JCO42M-RLBZ3DY-NM7PEQA";
   #     allowedNetwork = "192.168.0.0/16";
   #     autoAcceptFolders = true;
   #     addresses = [ "tcp://192.168.0.103:51820" ];
   #   };
   # };

   # settings.folders = {
   #   "XDG Share" = {
   #     id = "ukrub-quh7k";
   #     path = "/home/${user}/.local/share";
   #     devices = [ "Macbook Pro" "Home Lab" ];
   #   };
   # };

  #  settings.options.globalAnnounceEnabled = false; # Only sync on LAN
  #  settings.gui.insecureSkipHostcheck = true;
  #  settings.gui.insecureAdminAccess = true;
  #};

  # Add docker daemon
  #virtualisation.docker.enable = true;
  #virtualisation.docker.logDriver = "json-file";
  #virtualisation.docker.enableNvidia = true;

  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
    enableNvidia = true;
  };

  # Picom, my window compositor with fancy effects
  #
  # Notes on writing exclude rules:
  #
  #   class_g looks up index 1 in WM_CLASS value for an application
  #   class_i looks up index 0
  #
  #   To find the value for a specific application, use `xprop` at the
  #   terminal and then click on a window of the application in question
  #
  services.picom = {
    enable = true;
    settings = {
      animations = true;
      animation-stiffness = 300.0;
      animation-dampening = 35.0;
      animation-clamping = false;
      animation-mass = 1;
      animation-for-workspace-switch-in = "auto";
      animation-for-workspace-switch-out = "auto";
      animation-for-open-window = "slide-down";
      animation-for-menu-window = "none";
      animation-for-transient-window = "slide-down";
      corner-radius = 12;
      rounded-corners-exclude = [
        "class_i = 'polybar'"
        "class_g = 'i3lock'"
      ];
      round-borders = 3;
      round-borders-exclude = [];
      round-borders-rule = [];
      shadow = true;
      shadow-radius = 8;
      shadow-opacity = 0.4;
      shadow-offset-x = -8;
      shadow-offset-y = -8;
      fading = false;
      inactive-opacity = 0.8;
      frame-opacity = 0.7;
      inactive-opacity-override = false;
      active-opacity = 1.0;
      focus-exclude = [
      ];

      opacity-rule = [
        "100:class_g = 'i3lock'"
        "60:class_g = 'Dunst'"
        "80:class_g = 'Alacritty' && focused"
        "90:class_g = 'Alacritty' && !focused"
      ];

      blur-kern = "3x3box";
      blur = {
        method = "dual_kawase";
        strength = 15;
        background = false;
        background-frame = false;
        background-fixed = false;
        kern = "3x3box";
      };

      shadow-exclude = [
        "class_g = 'Dunst'"
         "override_redirect = true"
      ];

      blur-background-exclude = [
        "class_g = 'Dunst'"
      ];

      backend = "glx";
      vsync = false;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = false;
      detect-transient = true;
      detect-client-leader = true;
      use-damage = true;
      log-level = "info";

      wintypes = {
        normal = { fade = true; shadow = false; };
        tooltip = { fade = true; shadow = false; opacity = 0.75; focus = true; full-shadow = false; };
        dock = { shadow = false; };
        dnd = { shadow = false; };
        popup_menu = { opacity = 1.0; };
        dropdown_menu = { opacity = 1.0; };
      };
    };
  };

  # It's me, it's you, it's everyone
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = keys;
  };

  # Root user
  users.users.root = {
    openssh.authorizedKeys.keys = keys;
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
       {
         command = "${pkgs.systemd}/bin/reboot";
         options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  # Let's be able to SSH into this machine
  services.openssh.enable = true;

  # My shell
  programs.zsh.enable = true;

  # steam
  programs.steam.enable = true;

  # My editor runs as a daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable;
    startupTimeout = "7min"; # dustinlyons/nixpkgs
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    emacs-all-the-icons-fonts
    feather-font # dustinlyons/nixpkgs
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];

  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default # "x86_64-linux"
    gitAndTools.gitFull
    inetutils

    # sddm
    libsForQt5.sddm-kcm
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    # hyprland
    # swww # for wallpapers
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-hyprland
    # xwayland
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  system.stateVersion = "21.05"; # Don't change this

}
