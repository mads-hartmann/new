let
  sources = import ./sources.nix;
  nixpkgs = import sources.nixpkgs { };
  nix-pre-commit-hooks = import sources."pre-commit-hooks.nix";
in
nix-pre-commit-hooks.run {
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
}
