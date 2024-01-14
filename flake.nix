{
  description = "A basic flake for running nannou for educational purposes.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      devShells = rec {
        default = import ./basic-rust.nix { inherit pkgs system inputs; };
        comfyContinue = import ./comfy-continue.nix { inherit pkgs system inputs; };
        comfyNew = import ./comfy-new.nix { inherit pkgs system inputs; };
        comfyEnv = import ./comfy-env.nix { inherit pkgs system inputs; };
        ohMyGit = import ./oh-my-git.nix { inherit pkgs system inputs; };
        # todo: work on this once nannou is getting some momentum again
        nannou = import ./nannou.nix { inherit pkgs system inputs; };
      };
    }
  );
}
