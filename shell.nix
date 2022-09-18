# This file is being read by nix-shell. See 'man nix-shell' for more details on how this works.
let
  nixpkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f21492b413295ab60f538d5e1812ab908e3e3292.tar.gz") { };
  nix-pre-commit-hooks = import (fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/60cad1a326df17a8c6cf2bb23436609fdd83024e");
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      treefmt = {
        enable = true;
        name = "treefmt";
        entry = "${nixpkgs.treefmt}/bin/treefmt";
      };
      trailing-whitespace = {
        enable = true;
        name = "Trim Trailing Whitespace";
        description = "This hook trims trailing whitespace.";
        entry = "${nixpkgs.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
        types = [ "text" ];
      };
      end-of-line-fixer = {
        enable = true;
        name = "Fix End of Files";
        description = "Ensures that a file is either empty, or ends with one newline.";
        entry = "${nixpkgs.python3Packages.pre-commit-hooks}/bin/end-of-file-fixer";
        types = [ "text" ];
      };
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
