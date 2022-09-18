# This file is being read by nix-shell. See 'man nix-shell' for more details on how this works.
let
  nixpkgs = import <nixpkgs> { };
  nix-pre-commit-hooks = import (builtins.fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      treefmt = {
        enable = true;
        name = "treefmt";
        entry = "${nixpkgs.treefmt}/bin/treefmt";
      };
      # TODO: Fix these and maybe create issue upstead to understand if this is the
      # way to use the "normal" hooks.
      # trailing-whitespace = {
      #   enable = true;
      #   name = "trailing-whitespace";
      #   entry = "${nixpkgs.pre-commit}";
      # };
      # end-of-file-fixer = {
      #   enable = true;
      #   name = "end-of-file-fixer";
      #   entry = "${nixpkgs.pre-commit}";
      # };
    };
  };
in
nixpkgs.mkShell {
  nativeBuildInputs = [
    nixpkgs.man-db
    nixpkgs.less
    nixpkgs.tailscale
    # Docker
    # This is mainly to have a dev-loop for .gitpod.Dockerfile
    # slirp4netns is required by docker in rootless mode
    nixpkgs.slirp4netns
    nixpkgs.docker
    # Code formatting
    nixpkgs.treefmt
    nixpkgs.nixpkgs-fmt
    nixpkgs.nodePackages.prettier
  ];

  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
