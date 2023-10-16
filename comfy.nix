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
  ];
}
