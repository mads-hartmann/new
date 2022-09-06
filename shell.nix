# https://nix.dev/tutorials/declarative-and-reproducible-developer-environments
with import <nixpkgs> { };

mkShell {

  # Package names can be found via https://search.nixos.org/packages
  nativeBuildInputs = [
    direnv
    tailscale
  ];

  NIX_ENFORCE_PURITY = true;

  # Setting DIRENV_LOG_FORMAT to the empty string means direnv won't output
  # any logs when loading the environment. This makes things nice and quiet
  # but if you need to debug things, temporarily removing it might be helpful.
  shellHook =
    ''
    export DIRENV_LOG_FORMAT=""
    '';
}