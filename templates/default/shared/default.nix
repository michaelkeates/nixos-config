{ config, pkgs, ... }:

let
  installFonts = pkgs.writeText "install-fonts.sh" ''
    mkdir -p $out/share/fonts

    if [ "$(uname -s)" = "Darwin" ]; then
      fontDest=$out/Library/Fonts
    else
      fontDest=$out/share/fonts
    fi

    # Download fonts from the hidden GitHub repo
    git clone git+ssh://git@github.com/michaelkeates/personal-fonts.git
    unzip fonts.zip -d $out/share/fonts

    # Organize fonts (similar to previous script)
    for fontFile in $out/share/fonts/*; do
      fontType=$(file -b --mime-type "$fontFile")
      case "$fontType" in
        application/x-font-ttf)
          mv "$fontFile" $fontDest/TTF/
          ;;
        application/x-font-opentype)
          mv "$fontFile" $fontDest/OTF/
          ;;
        application/x-font-type1)
          mv "$fontFile" $fontDest/Type1/
          ;;
        *)
          mv "$fontFile" $fontDest/misc/
          ;;
      esac
    done

    rm -rf fonts.zip $out/share/fonts  # Clean up downloaded fonts
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
      src = null;  # No source needed, as we're downloading from a repo
      buildInputs = [ pkgs.bash unzip ];  # Ensure bash and unzip are available
      installPhase = installFonts;
    };
  };
}