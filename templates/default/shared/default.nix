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

    packages.thorium-browser = stdenv.mkDerivation rec {
      pname = "thorium-browser";
      version = "117.0.5938.157";

      src = stdenv.fetchurl {
        url = "https://github.com/Alex313031/thorium/releases/download/M${version}/thorium-browser_${version}_amd64.deb";
        hash = "sha256-muNBYP6832PmP0et9ESaRpd/BIwYZmwdkHhsMNBLQE4=";
      };

      nativeBuildInputs = [
        stdenv.autoPatchelfHook
        stdenv.dpkg
        stdenv.wrapGAppsHook
        stdenv.qt6.wrapQtAppsHook
      ];

      buildInputs = (if stdenv.isLinux then [
        stdenv.cc.cc.lib
        stdenv.alsa-lib
        stdenv.at-spi2-atk
        stdenv.at-spi2-core
        stdenv.cairo
        stdenv.cups
        stdenv.curl
        stdenv.dbus
        stdenv.expat
        stdenv.ffmpeg
        stdenv.fontconfig
        stdenv.freetype
        stdenv.glib
        stdenv.glibc
        stdenv.gtk3
        stdenv.gtk4
        stdenv.libcanberra
        stdenv.liberation_ttf
        stdenv.libexif
        stdenv.libglvnd
        stdenv.libkrb5
        stdenv.libnotify
        stdenv.libpulseaudio
        stdenv.libu2f-host
        stdenv.libva
        stdenv.libxkbcommon
        stdenv.mesa
        stdenv.nspr
        stdenv.nss
        stdenv.qt6.qtbase
        stdenv.pango
        stdenv.pciutils
        stdenv.pipewire
        stdenv.speechd
        stdenv.udev
        stdenv.unrar
        stdenv.vaapiVdpau
        stdenv.vulkan-loader
        stdenv.wayland
        stdenv.wget
        stdenv.xdg-utils
        stdenv.xfce.exo
        stdenv.xorg.libxcb
        stdenv.xorg.libX11
        stdenv.xorg.libXcursor
        stdenv.xorg.libXcomposite
        stdenv.xorg.libXdamage
        stdenv.xorg.libXext
        stdenv.xorg.libXfixes
        stdenv.xorg.libXi
        stdenv.xorg.libXrandr
        stdenv.xorg.libXrender
        stdenv.xorg.libXtst
        stdenv.xorg.libXxf86vm
      ] else [] ) ++ (if stdenv.isDarwin then [
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
          --replace 'export LD_LIBRARY_PATH' "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${ stdenv.lib.makeLibraryPath buildInputs }:$out/chromium.org/thorium:$out/chromium.org/thorium/lib" \
          --replace /usr $out

        runHook postInstall
      '';

      meta = with stdenv.lib; {
        description = "Compiler-optimized private Chromium fork";
        homepage = "https://thorium.rocks/index.html";
        sourceProvenance = with stdenv.sourceTypes; [ binaryNativeCode ];
        license = stdenv.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        mainProgram = "thorium-browser";
      };
    };
  };
}
