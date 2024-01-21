{ pkgs, system, inputs, ... }:
let
  rust = import ./fenix.nix { inherit system inputs; };
  vscode = import ./vscode.nix { inherit pkgs; };
in
pkgs.mkShell
rec {
  buildInputs = [
    rust
    vscode

    pkgs.pkg-config
    pkgs.openssl
  ];
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
  shellHook = '' 
    cd ~

    cargo new http-playground

    cd http-playground

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
}
