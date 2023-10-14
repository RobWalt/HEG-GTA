{ pkgs, system, fenix, ... }:
pkgs.mkShell rec {
  buildInputs = [
    (with fenix.packages.${system};  combine [
      stable.cargo
      stable.rustc
      stable.rust-src
      stable.rust-analyzer
      stable.clippy
      complete.rustfmt
    ])
  ];
}
