{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };

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
    HOMEDIR=~/comfy-projects
    mkdir -p $HOMEDIR
    cd $HOMEDIR
    ${pkgs.gum}/bin/gum style \
	    --foreground 212 --border-foreground 212 --border double \
	    --align center --width 50 --margin "1 2" --padding "2 4" \
	    'Pick the date you started the project'
    DATE=$(ls | ${pkgs.gum}/bin/gum choose)
    cd $DATE
    ${pkgs.gum}/bin/gum style \
	    --foreground 212 --border-foreground 212 --border double \
	    --align center --width 50 --margin "1 2" --padding "2 4" \
	    'Pick the project'
    PROJECT=$(ls | ${pkgs.gum}/bin/gum choose)
    ${vscode}/bin/code $PROJECT
    exit
  '';
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath comfyDeps;
}
