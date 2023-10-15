{ pkgs, system, inputs, ... }:
let
  nannou-new = import ./nannou-new.nix { inherit pkgs; };
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };
in
pkgs.mkShell
rec {
  buildInputs = [
    rust
    nannou-new
    vscode
  ];
}
