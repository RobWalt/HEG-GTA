{
  perSystem = { self', pkgs, ... }:
    let
      workflow = builtins.fetchGit {
        url = "https://github.com/DinEau/DinEau.github.io";
        ref = "main";
        rev = "64cb9af7ef09f28aa32e8c61ace94c7b55a4bb57";
      };
      theme = builtins.fetchGit {
        url = "https://codeberg.org/daudix/duckquill";
        ref = "main";
        rev = "296a03144f1e16d6c084282a7aafe21e783e1982";
      };
      dir = "zola-blank";
    in {
      packages = {
        copyGithubWorkflow = pkgs.writeShellScriptBin "git" ''
          cp -rf ${workflow}/.github .
          chmod -R 777 .github
        '';
        initGit = pkgs.writeShellScriptBin "init-git" ''
          export GIT_AUTHOR_NAME="Nix User"
          export GIT_AUTHOR_EMAIL="nix.user@example.com"
          export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
          export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

          ${pkgs.git}/bin/git init
          ${pkgs.git}/bin/git add -A
          ${pkgs.git}/bin/git commit -m "Initial Commit"
        '';
        createEmptyZola = pkgs.writeShellScriptBin "zola" ''
          mkdir ${dir}
          cd ${dir}
          cp -rf ${theme}/* .
          ${pkgs.coreutils}/bin/yes | rm .woodpecker.yaml README.md screenshot.png theme.toml
          chmod -R 777 .
        '';
      };
      devShells.website = pkgs.mkShell {
        packages = [ pkgs.zola ];
        shellHook = ''
          ${self'.packages.createEmptyZola}/bin/zola
          ${self'.packages.copyGithubWorkflow}/bin/git

          ${self'.packages.initGit}/bin/init-git

          ${pkgs.tree}/bin/tree
          ${pkgs.git}/bin/git log
          ${pkgs.zola}/bin/zola serve

          echo "Cleaning up"
          cd ..
          rm -rf ${dir}
          exit
        '';
      };
    };
}
