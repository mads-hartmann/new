# This file is being read by nix-shell. See man nix-shell for more details
# on how this works.
#
# Another useful resource:
#   https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
#
with import <nixpkgs> { };

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    git

    direnv
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

  NIX_ENFORCE_PURITY = true;

  shellHook =
    ''
    '';
}
