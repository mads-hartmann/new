# This file is being read by nix-shell. See 'man nix-shell' for more details
# on how this works.
#
# Another useful resource:
#   https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
#   https://nixos.org/manual/nix/stable/command-ref/nix-shell.html
#
with import <nixpkgs> { };

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    man-db
    less
    tailscale
    # Docker
    # This is mainly to have a dev-loop for .gitpod.Dockerfile
    # slirp4netns is required by docker in rootless mode
    slirp4netns
    docker
    # Code formatting
    treefmt
    nixpkgs-fmt
    nodePackages.prettier
  ];

  shellHook = ''
    ${(import ./default.nix).pre-commit-check.shellHook}
  '';
}
