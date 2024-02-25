{ inputs, ... }: {
  perSystem = { system, ... }:
    let
      fnx = inputs.fenix.packages.${system};
    in
    {
      packages.rust = fnx.combine [
        fnx.stable.cargo
        fnx.stable.rustc
        fnx.stable.rust-src
        fnx.stable.rust-analyzer
        fnx.stable.clippy
        fnx.complete.rustfmt
      ];
    };
}
