{ config, pkgs, lib, ... }:

let
  user = "mike";
in {
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    stateVersion = "21.05";
  };

  # Auto mount devices
  services.udiskie.enable = true;

  systemd.user.services.gpg-import-keys = {
    Unit = {
      Description = "Import gpg keys";
      After = [ "gpg-agent.socket" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeScript "gpg-import-keys" ''
        #! ${pkgs.runtimeShell} -el
        ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " []}
      '');
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}
