{ pkgs }:

with pkgs; [
  # General packages for development and system management
  act
  alacritty
  docker
  docker-compose
  bash-completion
  bat
  coreutils
  difftastic
  du-dust
  gcc
  git-filter-repo
  killall
  neofetch
  openssh
  pandoc
  wget
  utm
  transmission
  caprine-bin
  joplin-desktop
  vscode
  p7zip
  freerdp
  audacity
  ollama
  zed-editor

  # Photo and image editing tools
  gimp
  darktable
  handbrake

  # Encryption and security tools
  age
  age-plugin-yubikey
  bitwarden-cli
  gnupg
  libfido2
  pinentry
  yubikey-manager
  tailscale

  # Cloud-related tools and SDKs
  #docker
  #docker-compose
  awscli2
  ssm-session-manager-plugin

  # Media-related packages
  emacs-all-the-icons-fonts
  dejavu_fonts
  ffmpeg
  fd
  imagemagick
  font-awesome
  glow
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  xcolor
  wine64Packages.fonts
  google-fonts
  discord

  # Node.js development tools
  fzf
  nodePackages.live-server
  nodePackages.nodemon
  nodePackages.prettier
  nodePackages.npm
  nodejs

  # Source code management, Git, GitHub tools
  gh

  # Text and terminal utilities
  htop
  hunspell
  iftop
  #jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  unzip
  zsh-powerlevel10k
  nodePackages_latest.node-gyp

  # Python packages
  python310
  python310Packages.virtualenv

  # Gaming
  # dolphin-emu
]
