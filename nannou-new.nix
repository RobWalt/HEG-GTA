{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "nannou_new";
  version = "0.15.0";

  src = pkgs.fetchFromGitHub {
    owner = "nannou-org";
    repo = "nannou";
    rev = "v${version}";
    hash = "sha256-5uiHluuCdDNbpzKB/nG/Rmp0u3D6269CLxv1Yv69VqQ=";
  };

  cargoLock = {
    lockFile = ./nannou-cargo.lock;
  };

  sourceRoot = "${src.name}/nannou_new";

  cargoHash = "";

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  meta = with pkgs.lib; {
    description = "A simple interactive tool for generating projects.";
    homepage = "https://github.com/nannou-org/nannou";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ robwalt ];
  };
}
