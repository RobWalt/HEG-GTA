{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };

  comfy-main = pkgs.writeText "main.rs" '' 
use comfy::*;

simple_game!("Nice red circle", update);

fn update(_c: &mut EngineContext) {
    draw_circle(vec2(0.0, 0.0), 0.5, RED, 0);
}
  '';

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
    ${vscode}/bin/code .
    exit
  '';
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath comfyDeps;
}
