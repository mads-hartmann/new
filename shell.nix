# This file is being read by nix-shell. See 'man nix-shell' for more details on how this works.
let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
  pre-commit-check = import ./nix/pre-commit-check.nix;
in
nixpkgs.mkShell {
  nativeBuildInputs = [
    nixpkgs.niv
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
