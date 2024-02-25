{ inputs, ... }: {
  perSystem = { pkgs, lib, system, config, ... }:
    let
      inherit (config) packages;
    in
    {
      devShells.basic-rusty = pkgs.mkShell rec {
        buildInputs = [
          packages.rust
          packages.vscode

          pkgs.pkg-config
          pkgs.openssl
        ];
        LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
        shellHook = '' 
          cd ~
          
          cargo new playground
          
          cd playground
          
          if [ ! -d ".vscode" ]; then
            mkdir .vscode
          fi
          
          if [ ! -f ".vscode/tasks.json" ]; then
            echo '${builtins.readFile ./.vscode/tasks.json}' > .vscode/tasks.json
          fi
          
          if [ ! -f ".vscode/settings.json" ]; then
            echo '${builtins.readFile ./.vscode/settings.json}' > .vscode/settings.json
          fi
          
          code . 
        '';
      };
    };
}
