{ config, pkgs, ... }:

let
  fontDir = ./fonts;

installFonts = pkgs.writeText "install-fonts.sh" ''
  mkdir -p $out/share/fonts

  if [ "$(uname -s)" = "Darwin" ]; then
    fontDest=$out/Library/Fonts
  else
    fontDest=$out/share/fonts
  fi

  for fontFile in ${fontDir}/*; do
    fontType=$(file -b --mime-type "$fontFile")
    case "$fontType" in
      application/x-font-ttf)
        cp "$fontFile" $fontDest/TTF/
        ;;
      application/x-font-opentype)
        cp "$fontFile" $fontDest/OTF/
        ;;
      application/x-font-type1)
        cp "$fontFile" $fontDest/Type1/
        ;;
      *)
        cp "$fontFile" $fontDest/misc/
        ;;
    esac
  done
'';

  emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
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

    fonts = pkgs.stdenv.mkDerivation {
      name = "my-fonts";
      src = null;  # No source needed, as we're using local files
      buildInputs = [ pkgs.bash ];  # Ensure bash is available
      installPhase = installFonts;
    };
  };
}
