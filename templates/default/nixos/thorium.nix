{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      buildThorium = { system, name, version, url, sha256, appimageContents }:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.appimageTools.wrapType2 {
          inherit name version src = pkgs.fetchurl { url = url; sha256 = sha256; };
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/thorium-browser.desktop $out/share/applications/thorium-browser.desktop
            install -m 444 -D ${appimageContents}/thorium.png $out/share/icons/hicolor/512x512/apps/thorium.png
            substituteInPlace $out/share/applications/thorium-browser.desktop \
              --replace 'Exec=AppRun --no-sandbox %U' "Exec=${name} %U"
          '';
        };

      thoriumConfig = {
        x86_64-linux = buildThorium {
          system = "x86_64-linux";
          name = "thorium";
          version = "117.0.5938.157 - 53";
          url = "https://github.com/Alex313031/thorium/releases/download/M117.0.5938.157/Thorium_Browser_117.0.5938.157_x64.AppImage";
          sha256 = "sha256-dlfClBbwSkQg4stKZdSgNg3EFsWksoI21cxRG5SMrOM=";
          appimageContents = pkgs.appimageTools.extractType2 { inherit name; src = pkgs.fetchurl { url = url; sha256 = sha256; }; };
        };

        aarch64-linux = buildThorium {
          system = "aarch64-linux";
          name = "thorium";
          version = "117.0.5938.157 - 53";
          url = "https://github.com/Alex313031/Thorium-Raspi/releases/download/M117.0.5938.157/Thorium_Browser_117.0.5938.157_arm64.AppImage";
          sha256 = ""; # You should provide the correct sha256 value
          appimageContents = pkgs.appimageTools.extractType2 { inherit name; src = pkgs.fetchurl { url = url; sha256 = sha256; }; };
        };
      };
    in
    {
      packages = { inherit (thoriumConfig) x86_64-linux aarch64-linux; };
      apps = { inherit (thoriumConfig) x86_64-linux aarch64-linux; };
      defaultPackage = self.packages.x86_64-linux.thorium;
    };
}
