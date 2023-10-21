{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };

  mkTemplateFile = name: pkgs.writeText name (builtins.readFile ./comfy/templates/basic/${name});

  comfy-main = mkTemplateFile "main.rs";
  comfy-lib = mkTemplateFile "lib.rs";
  comfy-boilerplate = mkTemplateFile "boilerplate.rs";

  myInputs = [ rust vscode ];
  comfyDeps = with pkgs; [
    pkgconfig
    alsaLib
    vulkan-loader
    udev

    # x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11

    # wayland
    libxkbcommon
    wayland
  ];
in
pkgs.mkShell
rec {
  buildInputs = myInputs ++ comfyDeps;
  shellHook = '' 
    NIXOS_OZONE_WL=1 
    WLR_NO_HARDWARE_CURSORS=1
    WAYLAND_DISPLAY=wayland-1

    DATE=$(date -u +%Y-%m-%d)
    TMPDIR=$(mktemp -d)
    NAME=$(${pkgs.rust-petname}/bin/petname)
    HOMEDIR=~/comfy-projects/$DATE/
    mkdir -p $HOMEDIR
    ln -s $HOMEDIR $TMPDIR/comfy-new
    cd $TMPDIR/comfy-new
    cargo new $NAME --vcs=none
    cd $NAME
    cargo add comfy
    rm src/main.rs
    cat ${comfy-main} > src/main.rs
    cat ${comfy-lib} > src/lib.rs
    cat ${comfy-boilerplate} > src/boilerplate.rs
    echo "use $NAME::*;" | sed "s/-/_/g" >> src/main.rs
    ${vscode}/bin/code .
    exit
  '';
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath comfyDeps;
}
