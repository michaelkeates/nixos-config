{ description ? "Thorium using Nix Flake", inputs ? { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; } }:

let
  pkgs = import inputs.nixpkgs { };
  name = "thorium";
  version = "117.0.5938.157 - 53";
  src = pkgs.fetchurl {
    url = "https://github.com/Alex313031/thorium/releases/download/M117.0.5938.157/Thorium_Browser_117.0.5938.157_x64.AppImage";
    sha256 = "sha256-dlfClBbwSkQg4stKZdSgNg3EFsWksoI21cxRG5SMrOM=";
  };
  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in
pkgs.appimageTools.wrapType2 {
  inherit name version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
    install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
    substituteInPlace $out/share/applications/thorium-browser.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} %U'
  '';
};
