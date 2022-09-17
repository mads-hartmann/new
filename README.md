# `new`

This is my starting point for _new_ things.

TL;DR: nix is used to define the build environment (specifically nix-shell which reads shell.nix by default).

The basic setup ...

- [nix](https://nix.dev) is used to manage dependencies configure the shell
  which means nix controls my shell through [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html).
- [treefmt](https://github.com/numtide/treefmt) takes care of formatting all the source code.

## TODOs

Before switching to nix (merging this branch) I want to

- Document shell.nix better
- Finish the README
- Git hooks
  - See https://github.com/cachix/pre-commit-hooks.nix as a way to mange [pre-commit](https://pre-commit.com/) with nix.
  - Run treefmt as part of the githook

## Decisions and future improvements

### Not using direnv

## Not using direnv

- [direnv](https://direnv.net/) is used to have folder-specific shell configurations. Right now it's mostly useful to have `ùse nix`

```dockerfile
 # Install a few Nix packages for the Gitpod users Nix profile.
 #
 # This will make the binaries available to the gitpod even outside of a specific
 # nix-shell.
 RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -i \
        direnv
```

```yaml
- name: Prepare
  before: |
    # Configure direnv
    #
    # Setting DIRENV_LOG_FORMAT to the empty string means direnv won't output
    # any logs when loading the environment. This makes things nice and quiet
    # but if you need to debug things, temporarily removing it might be helpful.
    direnv hook bash >> /home/gitpod/.bashrc
    echo 'export DIRENV_LOG_FORMAT=""' >> /home/gitpod/.bashrc
    direnv allow
```

### Not using Gitpod init task

TODO: A simple workaround for now would be to COPY shell.nix in the Dockerfile and run `nix-shell --run "exit 0"` there. Then we can get rid of `gp sync-done nix-setup`

Currently the nix store is located in `/nix/store` which is unfortunately as it means we can't populate the store during prebuilds as those only save files in `/workspace` ([ref](https://www.gitpod.io/docs/prebuilds#workspace-directory-only))

Using `NIX_STORE_DIR=/workspace/nix` seems to break the Nix installer.

Otherwise we could have had the following `init` command to install all dependencies as part of a prebuild

```yaml
init: |
  time nix-shell --run "exit 0"
  gp sync-done nix-setup
```
