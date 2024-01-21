{ pkgs }:

with pkgs; [
  # General packages for development and system management
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
  openssh
  pandoc
  wget
]
