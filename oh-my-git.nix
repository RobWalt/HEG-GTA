{ pkgs, system, inputs, ... }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    git
  ];
  shellHook = ''
    nix run nixpkgs#oh-my-git;
    exit
  '';
}
