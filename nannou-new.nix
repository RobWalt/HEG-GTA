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

  # cargoLock = {
  #   lockFile = ./nannou-cargo.lock;
  #   outputHashes = {
  #     "hotglsl-0.1.0" = "sha256-G88Sa/tgGppaxIIPXDqIazMWRBXpaSFb2mulNfCclm8=";
  #     "isf-0.1.0" = "sha256-utexaXpZZgpRunVAQyD2JAwvabhZGzeorC4pRFIumAc=";
  #     "skeptic-0.13.4" = "sha256-EZFtWIPfsfbpGBD8NwsVtMzRM10kVdg+djoV00dhT4Y=";
  #   };
  # };

  cargoPatches = [
    ./nannou_new.patch
  ];

  sourceRoot = "${src.name}/nannou_new";

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD=";

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  meta = with pkgs.lib; {
    description = "A simple interactive tool for generating projects.";
    homepage = "https://github.com/nannou-org/nannou";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ robwalt ];
  };
}
