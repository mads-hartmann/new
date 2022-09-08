# `new`

This is my starting point for _new_ things.

TL;DR: nix is used to define the build environment (specifically nix-shell which reads shell.nix by default). direnv is used to hook into bash to set up by shell environment per folder (defined in .envrc).

The basic setup ...

- [nix](https://nix.dev) is used to manage dependencies configure the shell
- [direnv](https://direnv.net/) is used to have folder-specific shell configurations. Right now it's mostly useful to have `ùse nix` which means nix controls my shell through [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html).
- [treefmt](https://github.com/numtide/treefmt) takes care of formatting all the source code.
