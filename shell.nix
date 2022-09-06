# https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
with import <nixpkgs> { };

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    direnv
    tailscale
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
