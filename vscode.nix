{ pkgs, ... }:
pkgs.vscode-with-extensions.override {
  vscodeExtensions = with pkgs.vscode-extensions; [
    rust-lang.rust-analyzer
    catppuccin.catppuccin-vsc
  ];
}
