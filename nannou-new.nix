{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "nannou_new";
  version = "0.18.0";

  src = pkgs.fetchFromGitHub {
    owner = "nannou-org";
    repo = "nannou";
    rev = "v${version}";
    hash = "";
  };

  sourceRoot = "${src.name}/nannou_new";

  cargoHash = "";
  nativeBuildInputs = [ ];

  buildInputs = [ ];

  meta = with pkgs.lib; {
    description = "A simple interactive tool for generating projects.";
    homepage = "https://github.com/nannou-org/nannou";
    license = with pkgs.licenses; [ mit /* or */ apache ];
    maintainers = with pkgs.maintainers; [ robwalt ];
  };
}
