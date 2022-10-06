# This file is being read by nix-shell. See 'man nix-shell' for more details on how this works.
let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs { };
  nix-pre-commit-hooks = import sources."pre-commit-hooks.nix";
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
