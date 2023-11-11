# thorium.nix

{ lib, stdenv, fetchurl, autoPatchelfHook, dpkg, wrapGAppsHook, alsa-lib, at-spi2-atk, at-spi2-core, cairo, cups, curl, dbus, expat, ffmpeg, fontconfig, freetype, glib, glibc, gtk3, gtk4, libcanberra, liberation_ttf, libexif, libglvnd, libkrb5, libnotify, libpulseaudio, libu2f-host, libva, libxkbcommon, mesa, nspr, nss, pango, pciutils, pipewire, speechd, udev, _7zz, vaapiVdpau, vulkan-loader, wayland, wget, xdg-utils, xfce, xorg, qt6 }:

stdenv.mkDerivation rec {
  pname = "thorium-browser";
  version = "117.0.5938.157";

  src = fetchurl {
    url = "https://github.com/Alex313031/thorium/releases/download/M${version}/thorium-browser_${version}_amd64.deb";
    hash = "sha256-muNBYP6832PmP0et9ESaRpd/BIwYZmwdkHhsMNBLQE4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    # ... Other dependencies are omitted here, as they are specified in packages.nix
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Widgets.so.5"
    "libQt5Gui.so.5"
    "libQt5Core.so.5"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -vr usr/* $out
    cp -vr etc $out
    cp -vr opt $out
    ln -sf $out/opt/chromium.org/thorium/thorium-browser $out/bin/thorium-browser
    substituteInPlace $out/share/applications/thorium-shell.desktop \
      --replace /usr/bin $out/bin \
      --replace /opt $out/opt
    substituteInPlace $out/share/applications/thorium-browser.desktop \
      --replace /usr/bin $out/bin \
      --replace StartupWMClass=thorium StartupWMClass=thorium-browser \
      --replace Icon=thorium-browser Icon=$out/opt/chromium.org/thorium/product_logo_256.png
    addAutoPatchelfSearchPath $out/chromium.org/thorium
    addAutoPatchelfSearchPath $out/chromium.org/thorium/lib
    substituteInPlace $out/opt/chromium.org/thorium/thorium-browser \
      --replace 'export LD_LIBRARY_PATH' "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${lib.makeLibraryPath buildInputs}:$out/chromium.org/thorium:$out/chromium.org/thorium/lib"
    makeWrapper "$out/opt/chromium.org/thorium/thorium-browser" "$out/bin/thorium-browser" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Compiler-optimized Chromium fork";
    homepage = "https://thorium.rocks";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [isabelroses];
    license = licenses.bsd3;
    platforms = ["x86_64-linux"];
    mainProgram = "thorium-browser";
  };
}
