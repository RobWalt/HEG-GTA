{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      inherit (inputs.jupyenv.lib.${system}) mkJupyterlabNew;
    in
    {

      packages.julia-jupyter = mkJupyterlabNew (_: {
        inherit (inputs) nixpkgs;
        kernel.julia.HEG-GTA = {
          enable = true;
          ijuliaRev = "bHdNn";
        };
      });

    };
}
