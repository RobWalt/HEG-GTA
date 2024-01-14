{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };
in
pkgs.mkShell
rec {
  buildInputs = [
    rust
    vscode

    pkgs.pkg-config
    pkgs.openssl
  ];
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
  shellHook = '' 
    ${vscode}/bin/code ~/
    exit
  '';
}
