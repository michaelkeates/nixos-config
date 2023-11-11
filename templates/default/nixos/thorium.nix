{ nixpkgs, ... }:

let
  # Import the packages from packages.nix
  packages = import ./packages.nix { inherit nixpkgs; };

in
packages.thorium-browser.overrideAttrs (oldAttrs: rec {
  pname = "thorium-browser";
  version = "117.0.5938.157";

  src = packages.fetchurl {
    url = "https://github.com/Alex313031/thorium/releases/download/M${version}/thorium-browser_${version}_amd64.deb";
    hash = "sha256-muNBYP6832PmP0et9ESaRpd/BIwYZmwdkHhsMNBLQE4=";
  };

  nativeBuildInputs = [
    packages.autoPatchelfHook
    packages.dpkg
    packages.wrapGAppsHook
    packages.qt6.wrapQtAppsHook
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
      --replace 'export LD_LIBRARY_PATH' "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${packages.lib.makeLibraryPath buildInputs}:$out/chromium.org/thorium:$out/chromium.org/thorium/lib"
    makeWrapper "$out/opt/chromium.org/thorium/thorium-browser" "$out/bin/thorium-browser" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    runHook postInstall
  '';

  meta = with packages.lib; {
    description = "Compiler-optimized Chromium fork";
    homepage = "https://thorium.rocks";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [isabelroses];
    license = licenses.bsd3;
    platforms = ["x86_64-linux"];
    mainProgram = "thorium-browser";
  };
})
