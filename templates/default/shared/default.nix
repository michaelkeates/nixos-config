let
  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = true;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))

      ++ [(import (builtins.fetchTarball {
               url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
               sha256 = emacsOverlaySha256;
           }))];

    packages.thorium-browser = pkgs.stdenv.mkDerivation rec {
      pname = "thorium-browser";
      version = "117.0.5938.157";

      src = pkgs.fetchurl {
        url = "https://github.com/Alex313031/thorium/releases/download/M${version}/thorium-browser_${version}_amd64.deb";
        hash = "sha256-muNBYP6832PmP0et9ESaRpd/BIwYZmwdkHhsMNBLQE4=";
      };

      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.dpkg
        pkgs.wrapGAppsHook
        pkgs.qt6.wrapQtAppsHook
      ];

      buildInputs = (if pkgs.stdenv.isLinux then [
        pkgs.stdenv.cc.cc.lib
        pkgs.alsa-lib
        pkgs.at-spi2-atk
        pkgs.at-spi2-core
        pkgs.cairo
        pkgs.cups
        pkgs.curl
        pkgs.dbus
        pkgs.expat
        pkgs.ffmpeg
        pkgs.fontconfig
        pkgs.freetype
        pkgs.glib
        pkgs.glibc
        pkgs.gtk3
        pkgs.gtk4
        pkgs.libcanberra
        pkgs.liberation_ttf
        pkgs.libexif
        pkgs.libglvnd
        pkgs.libkrb5
        pkgs.libnotify
        pkgs.libpulseaudio
        pkgs.libu2f-host
        pkgs.libva
        pkgs.libxkbcommon
        pkgs.mesa
        pkgs.nspr
        pkgs.nss
        pkgs.qt6.qtbase
        pkgs.pango
        pkgs.pciutils
        pkgs.pipewire
        pkgs.speechd
        pkgs.udev
        pkgs.unrar
        pkgs.vaapiVdpau
        pkgs.vulkan-loader
        pkgs.wayland
        pkgs.wget
        pkgs.xdg-utils
        pkgs.xfce.exo
        pkgs.xorg.libxcb
        pkgs.xorg.libX11
        pkgs.xorg.libXcursor
        pkgs.xorg.libXcomposite
        pkgs.xorg.libXdamage
        pkgs.xorg.libXext
        pkgs.xorg.libXfixes
        pkgs.xorg.libXi
        pkgs.xorg.libXrandr
        pkgs.xorg.libXrender
        pkgs.xorg.libXtst
        pkgs.xorg.libXxf86vm
      ] else [] ) ++ (if pkgs.stdenv.isDarwin then [
        # Add macOS-specific dependencies here
      ] else []);

      autoPatchelfIgnoreMissingDeps = [
        "libQt5Widgets.so.5"
        "libQt5Gui.so.5"
        "libQt5Core.so.5"
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r usr/* $out
        cp -r etc $out
        cp -r opt $out
        ln -sf $out/opt/chromium.org/thorium/thorium-browser $out/bin/thorium-browser
        rm $out/share/applications/thorium-shell.desktop

        substituteInPlace $out/share/applications/thorium-browser.desktop \
          --replace /usr/bin $out/bin \
          --replace StartupWMClass=thorium StartupWMClass=thorium-browser \
          --replace Icon=thorium-browser Icon=$out/opt/chromium.org/thorium/product_logo_256.png

        addAutoPatchelfSearchPath $out/chromium.org/thorium
        addAutoPatchelfSearchPath $out/chromium.org/thorium/lib
        substituteInPlace $out/opt/chromium.org/thorium/thorium-browser \
          --replace 'export LD_LIBRARY_PATH' "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${ pkgs.lib.makeLibraryPath buildInputs }:$out/chromium.org/thorium:$out/chromium.org/thorium/lib" \
          --replace /usr $out

        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Compiler-optimized private Chromium fork";
        homepage = "https://thorium.rocks/index.html";
        sourceProvenance = with pkgs.sourceTypes; [ binaryNativeCode ];
        license = pkgs.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        mainProgram = "thorium-browser";
      };
    };
  };
}
