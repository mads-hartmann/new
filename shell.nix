# This file is being read by nix-shell. See man nix-shell for more details
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
    # Docker and docker-compose
    slirp4netns #TODO: Why do I need this?
    docker
    docker-compose
    # Code formatting
    treefmt
    nixpkgs-fmt
    nodePackages.prettier
  ];

  shellHook =
    ''
    '';
}
