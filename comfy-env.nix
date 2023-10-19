{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };

  myInputs = [ rust ];
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
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath comfyDeps;
}
