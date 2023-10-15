{ system, inputs, ... }: with inputs.fenix.packages.${system};
combine [
  stable.cargo
  stable.rustc
  stable.rust-src
  stable.rust-analyzer
  stable.clippy
  complete.rustfmt
]
