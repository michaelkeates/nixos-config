{ pkgs }:

with pkgs; [
  # General packages for development and system management
  act
  alacritty
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
  rpi-imager
  audacity

  # Photo and image editing tools
  gimp
  #darktable

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
  docker
  docker-compose
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
  google-fonts
  xcolor
  wine64Packages.fonts
  handbrake

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
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  unzip
  zsh-powerlevel10k

  # Python packages
  python39
  python39Packages.virtualenv
]
