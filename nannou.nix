{ pkgs, system, inputs, ... }:
let
  nannou-new = import ./nannou-new.nix { inherit pkgs; };
in
pkgs.mkShell
rec {
  buildInputs = [
    (with inputs.fenix.packages.${system};  combine [
      stable.cargo
      stable.rustc
      stable.rust-src
      stable.rust-analyzer
      stable.clippy
      complete.rustfmt
    ])
    nannou-new
  ];
}
