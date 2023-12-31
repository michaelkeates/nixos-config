{ config, pkgs, lib, ... }:

let
  user = "mike";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };

  polybar-user_modules = builtins.readFile (pkgs.substituteAll {
    src = ./config/polybar/user_modules.ini;
    packages = "${xdg_configHome}/polybar/bin/check-nixos-updates.sh";
    searchpkgs = "${xdg_configHome}/polybar/bin/search-nixos-updates.sh";
    launcher = "${xdg_configHome}/polybar/bin/launcher.sh";
    powermenu = "${xdg_configHome}/rofi/bin/powermenu.sh";
    calendar = "${xdg_configHome}/polybar/bin/popup-calendar.sh";
  });

  polybar-config = pkgs.substituteAll {
      src = ./config/polybar/config.ini;
      font0 = "DejaVu Sans:size=12;3";
      font1 = "feather:size=12;3"; # dustinlyons/nixpkgs
  };

  polybar-modules = builtins.readFile ./config/polybar/modules.ini;
  polybar-bars = builtins.readFile ./config/polybar/bars.ini;
  polybar-colors = builtins.readFile ./config/polybar/colors.ini;

  # These files are generated when secrets are decrypted at build time
  gpgKeys = [
    "/home/${user}/.ssh/pgp_github.key"
    "/home/${user}/.ssh/pgp_github.pub"
  ];
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "21.05";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.whitesur-gtk-theme;
      name = "WhiteSur-gtk-theme";
    };
    iconTheme = {
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur";
    };
    font = {
      name = "SF Pro Text";
      size = 11;
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
      size = 30;
    };
  };

  # Screen lock
  services.screen-locker = {
    enable = true;
    inactiveInterval = 10;
    lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 10 15";
  };

  # Auto mount devices
  services.udiskie.enable = true;

  services.polybar = {
    enable = true;
    config = polybar-config;
    extraConfig = polybar-bars + polybar-colors + polybar-modules + polybar-user_modules;
    package = pkgs.polybarFull;
    script = "polybar main &";
  };

  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
      monitor = 0;
      follow = "mouse";
      border = 0;
      height = 400;
      width = 320;
      offset = "33x65";
      indicate_hidden = "yes";
      shrink = "no";
      separator_height = 0;
      padding = 32;
      horizontal_padding = 32;
      frame_width = 0;
      sort = "no";
      idle_threshold = 120;
      font = "Noto Sans";
      line_height = 4;
      markup = "full";
      format = "<b>%s</b>\n%b";
      alignment = "left";
      transparency = 10;
      show_age_threshold = 60;
      word_wrap = "yes";
      ignore_newline = "no";
      stack_duplicates = false;
      hide_duplicate_count = "yes";
      show_indicators = "no";
      icon_position = "left";
      icon_theme = "Adwaita-dark";
      sticky_history = "yes";
      history_length = 20;
      history = "ctrl+grave";
      browser = "google-chrome-stable";
      always_run_script = true;
      title = "Dunst";
      class = "Dunst";
      max_icon_size = 64;
    };
    };
  };

  programs = shared-programs // { gpg.enable = true; };

  # This installs my GPG signing keys for Github
  systemd.user.services.gpg-import-keys = {
    Unit = {
      Description = "Import gpg keys";
      After = [ "gpg-agent.socket" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeScript "gpg-import-keys" ''
        #! ${pkgs.runtimeShell} -el
        ${lib.optionalString (gpgKeys!= []) ''
        ${pkgs.gnupg}/bin/gpg --import ${lib.concatStringsSep " " gpgKeys}
        ''}
      '');
    };

    Install = { WantedBy = [ "default.target" ]; };
  };

systemd.user.services.bspwmrc = {
  Unit = {
    Description = "Run bspwmrc on user login";
    After = ["graphical-session.target"];
  };

  Service = {
    Type = "oneshot";
    ExecStart = "${pkgs.bash}/bin/bash ${config.home.homeDirectory}/.local/share/src/nixos-config/nixos/config/bspwmrc";
    RemainAfterExit = true;
  };

  Install = {
    WantedBy = ["default.target"];
  };
};

}
