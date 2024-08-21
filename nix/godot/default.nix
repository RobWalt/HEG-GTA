{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.maker = { name }: pkgs.mkShell { inherit name; };

      devShells.godot-snake =
        let
          repo = pkgs.fetchFromGitHub {
            owner = "russs123";
            repo = "snake_tutorial";
            rev = "ef48461bd67b63689fe72eaaaae7dd385137aa01";
            sha256 = "sha256-5KFYf3nZLOMeAWYC4nXIzJmJB69myONZpa+oYuN6PvE=";
          };
        in
        inputs.flake-lib.mkShell {
          inherit pkgs;
          name = "godot-snake";
          packages = [ pkgs.godot_4 ];
          shellHook = ''
            cp -rf ${repo}/assets .
            godot4
          '';
        };

    };
}
