let
  nix-pre-commit-hooks = import (builtins.fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
in
{
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      treefmt = {
        enable = true;
        name = "treefmt";
        # TODO: Find a way to refernece the absolute path to treefmt
        entry = "treefmt";
      };
    };
  };
}
