{
  mkShell =
    {
      pkgs,
      name,
      packages,
      shellHook,
    }:
    pkgs.mkShell {
      inherit name packages;
      shellHook = ''
        mkdir -p ~/HEG-GTA-Programmieren/${name}
        pushd ~/HEG-GTA-Programmieren/${name}
        ${shellHook}
        popd
        exit
      '';
    };
}
