{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Security and authentication
  bitwarden

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  gimp
  wineWowPackages.stable
  fontconfig
  font-manager
  nextcloud-client
  darktable
  blender

  # Printers and drivers
  brlaser # printer driver

  # Calculators
  bc # old school calculator
  galculator

  # Audio tools
  cava # Terminal audio visualizer
  pavucontrol # Pulse audio controls

  # Messaging and chat applications
  discord
  #tdesktop # telegram desktop

  # Testing and development tools
  cypress # Functional testing framework using headless chrome
  chromedriver
  direnv
  rofi
  rofi-calc
  rnix-lsp # lsp-mode for nix
  qmk
  libusb1 # for Xbox controller
  libtool # for Emacs vterm
  github-desktop

  # Screenshot and recording tools
  flameshot
  simplescreenrecorder

  # Text and terminal utilities
  emote # Emoji picker
  feh # Manage wallpapers
  screenkey
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  i3lock-fancy-rapid
  libnotify
  playerctl # Control media players from command line
  pinentry-curses
  pcmanfm # Our file browser
  xdg-utils
  blueman
  onlyoffice-bin

  # Other utilities
  yad # I use yad-calendar with polybar
  xdotool
  google-chrome
  thunderbird
  obs-studio
  github-desktop

  # PDF viewer
  zathura

  # Music and entertainment

]
