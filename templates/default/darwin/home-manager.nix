{ config, pkgs, lib, home-manager, ... }:

let
  user = "mike";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew.enable = true;
  homebrew.onActivation = {
    cleanup = "zap";
    autoUpdate = true;
    upgrade = true;
  };
  homebrew.casks = pkgs.callPackage ./casks.nix {};

  # These app IDs are from using the mas CLI app
  # mas = mac app store
  # https://github.com/mas-cli/mas
  #
  # $ nix shell nixpkgs#mas
  # $ mas search <app name>
  #
  homebrew.masApps = {
    "Microsoft Remote Desktop" = 1295203466;
    "Infuse" = 1136220934;
    "Spark" = 1176895641;
    "Tailscale" = 1475387142;
    "WhatsApp Messenger" = 310633997;
    "Steam Link" = 1246969117;
    "Color Picker" = 1545870783;
    "Prime Video" = 545519333;
    "Xcode" = 497799835;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.file = lib.mkMerge [
        sharedFiles
        additionalFiles
        { "emacs-launcher.command".source = myEmacsLauncher; }
      ];
      home.activation.gpgImportKeys =
        let
          gpgKeys = [
            "/Users/${user}/.ssh/pgp_github.key"
            "/Users/${user}/.ssh/pgp_github.pub"
          ];
          gpgScript = pkgs.writeScript "gpg-import-keys" ''
            #! ${pkgs.runtimeShell} -el
            ${lib.optionalString (gpgKeys != []) ''
              ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " gpgKeys}
            ''}
          '';
          plistPath = "$HOME/Library/LaunchAgents/importkeys.plist";
        in
          # Prior to the write boundary: no side effects. After writeBoundary, side effects.
          # We're creating a new plist file, so we need to run this after the writeBoundary
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p "$HOME/Library/LaunchAgents"
            cat >${plistPath} <<EOF
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
              <key>Label</key>
              <string>gpg-import-keys</string>
              <key>ProgramArguments</key>
              <array>
                <string>${gpgScript}</string>
              </array>
              <key>RunAtLoad</key>
              <true/>
            </dict>
            </plist>
            EOF

            /bin/launchctl unload ${plistPath} || true
            /bin/launchctl load ${plistPath}
          '';

      home.stateVersion = "23.11";
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/System/Applications/Messages.app/"; }
    { path = "/Applications/Thorium.app/"; }
    { path = "/System/Applications/System Settings.app/"; }
    {
      path = toString myEmacsLauncher;
      section = "others";
    }
    {
      #path = "${config.users.users.${user}.home}/.local/share/";
      path = "/Users/${user}/.local/share/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      #path = "${config.users.users.${user}.home}/.local/share/downloads";
      path = "/Users/${user}/downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];
}
