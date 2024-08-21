{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {

      devShells.godot-snake =
        let
          repo = pkgs.fetchFromGitHub {
            owner = "russs123";
            repo = "snake_tutorial";
            rev = "ef48461bd67b63689fe72eaaaae7dd385137aa01";
            sha256 = "sha256-5KFYf3nZLOMeAWYC4nXIzJmJB69myONZpa+oYuN6PvE=";
          };
        in
        pkgs.mkShell {
          name = "godot-snake";
          packages = [ pkgs.godot_4 ];
          shellHook = ''
            mkdir -p ~/godot-snake
            cd ~/godot-snake
            cp -rf ${repo}/assets .
            godot4
            exit
          '';
        };

    };
}
