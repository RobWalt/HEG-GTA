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
    vscode

    # doesnt work yet, everything is too old and also building taskes ages
    # nannou-new
  ];
}
