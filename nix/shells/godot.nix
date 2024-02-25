{
  perSystem = { pkgs, ... }: {
    devShells.godot = pkgs.mkShell rec {
      buildInputs = [ pkgs.godot_4 ];
    };
  };
}
