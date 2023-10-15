{ pkgs, ... }:
pkgs.rustPlatform.buildRustPackage
rec
{
  pname = "nannou_new";
  version = "0.15.0";

  src = pkgs.fetchFromGitHub {
    owner = "nannou-org";
    repo = "nannou";
    rev = "v${version}";
    hash = "sha256-5uiHluuCdDNbpzKB/nG/Rmp0u3D6269CLxv1Yv69VqQ=";
  };

  cargoPatches = [
    # this patch deletes anything but nannou_new from the workspace to make it the only crate there
    # other crates deal with other git based dependencies which makes the whole thing much worse to
    # package even though we don't even need those dependencies
    #
    # if anyone has to do this again: 
    #
    # - remove the Cargo.lock from .gitignore if it's still there
    # - remove all packages but nannou_new from the workspace
    # - create the lock file by running cargo update
    # - commit everything
    # - create the patch by running something like `git diff HEAD~ > nannou_new.patch`
    # 
    # even then it didn't work since cargo wanted to update the lock file again
    # to debug this, look at what's updated by cargo by uncommenting this
    #
    # configurePhase = '' 
    #  cargo update --dry-run -v
    # ''
    #
    # in my case, I just needed to manually bump the version of nannou_new in the patch
    ./nannou_new.patch
    # the current version of nannou_new needed some update love to work again since some
    # dependencies are pretty old
    ./nannou_new_update.patch
  ];

  cargoHash = "sha256-36qYItOsJEluv2YNiOxZGoBruWnWnx7Ggf2IL9+YYkU=";

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pkgs.openssl ];

  meta = with pkgs.lib; {
    description = "A simple interactive tool for generating projects.";
    homepage = "https://github.com/nannou-org/nannou";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ robwalt ];
  };
}
