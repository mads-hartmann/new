# `new`

This is my starting point for _new_ things.

TL;DR: nix is used to define the build environment (specifically nix-shell which reads shell.nix by default). direnv is used to hook into bash to set up by shell environment per folder (defined in .envrc).

The basic setup ...

- [nix](https://nix.dev) is used to manage dependencies configure the shell
- [direnv](https://direnv.net/) is used to have folder-specific shell configurations. Right now it's mostly useful to have `ùse nix` which means nix controls my shell through [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html).
- [treefmt](https://github.com/numtide/treefmt) takes care of formatting all the source code.

## Future improvements

Currently the nix store is located in `/nix/store` which is unfortunately as it means we can't populate the store during prebuilds as those only save files in `/workspace` ([ref](https://www.gitpod.io/docs/prebuilds#workspace-directory-only))

Using `NIX_STORE_DIR=/workspace/nix` seems to break the Nix installer.

Otherwise we could have had the following `init` command to install all dependencies as part of a prebuild

```yaml
init: |
  time nix-shell --run "exit 0"
  gp sync-done nix-setup
```
