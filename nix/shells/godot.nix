{
  perSystem = { pkgs, ... }: {
    devShells.godot = pkgs.mkShell rec {
      packages = [ pkgs.godot_4 ];
      shellHook = "
      godot4
      exit
      ";
    };
  };
}
