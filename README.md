# `new`

This is my starting point for _new_ things; it's my ["dotfiles" but "for computers"](https://ghuntley.com/slash-new/).

It uses [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html) to provide a [declarative and reproducible developer environment](https://nix.dev/tutorials/declarative-and-reproducible-developer-environments) and been optimized to run in [Gitpod](https://gitpod.io/).

The basic setup ...

- [nix](https://nix.dev) is used to manage dependencies configure the shell
  which means nix controls my shell through [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html).
- [treefmt](https://github.com/numtide/treefmt) takes care of formatting all the source code.

Credit goes to [Geoffrey Huntley](https://ghuntley.com/) for the idea of [/new](https://ghuntley.com/slash-new/) and the original code in [ghuntley/new](https://github.com/ghuntley/new) which I used as a starting point.

## TODOs

Before switching to nix (merging this branch) I want to

- Document shell.nix better
- Finish the README
- Git hooks
  - See https://github.com/cachix/pre-commit-hooks.nix as a way to mange [pre-commit](https://pre-commit.com/) with nix.
  - Run treefmt as part of the githook
- Version locking (forgot the name of the tool)

## Notes

### Not using a Gitpod `init` task

Populating the Nix store with all the packages that are required by `shell.nix` is the kind of task that fits really nicely with [Gitpod Prebuilds](https://www.gitpod.io/docs/prebuilds). However, currently prebuilds only save files in the `/workspace` directory ([see docs](https://www.gitpod.io/docs/prebuilds#workspace-directory-only)) and I couldn't get Nix to use `/workspace/nix/store` as the location of the Nix store, so for now, using an `init` task to populate the store isn't possible.

Instead I populate the Nix store in the Dockerfile by `COPY`ing in shell.nix and running `nix-shell --run "exit 0"`.

### Not using direnv

[direnv](https://direnv.net/) is a neat way to have folders-specific shell environments which integrates really nicely with nix-shell. I decided against including it in this repository as I want to keep things as simple as possible. However, if I wanted to add it agin here's how to do it:

In the `.gitpod.Dockerfile` add:

```dockerfile
 # Install a few Nix packages for the Gitpod users Nix profile.
 #
 # This will make the binaries available to the gitpod even outside of a specific
 # nix-shell.
 RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -i \
        direnv
```

In the `.gitpod.yml` file add:

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
