{ config, pkgs, ... }:

let
  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";

  min = pkgs.buildFHSUserEnv {
    name = "min";
    targetPkgs = pkgs: [ pkgs.nodejs pkgs.libsecret pkgs.electron19 ];

    runScript = ''
      git clone https://github.com/minbrowser/min.git
      cd min
      npm install
      npm run build
      cp -r * $out
    '';

  };

in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))

      ++ [(import (builtins.fetchTarball {
               url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
               sha256 = emacsOverlaySha256;
           }))];
  };

  environment.systemPackages = with pkgs; [
    # ... (existing packages) ...
    min  // Add 'min' to the list of system packages
  ];
}
