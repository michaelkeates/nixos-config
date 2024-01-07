{ config, pkgs, lib, ... }:

let name = "Michael Keates";
    user = "michaelkeates";
    email = "mail@michaelkeates.co.uk"; in
{

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
