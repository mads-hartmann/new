# `new`

This is my starting point for _new_ things; it's my ["dotfiles" but "for computers"](https://ghuntley.com/slash-new/).

It uses [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html) to provide a [declarative and reproducible developer environment](https://nix.dev/tutorials/declarative-and-reproducible-developer-environments) and is meant to be run in [Gitpod](https://gitpod.io/).

[Tailscale](https://tailscale.com/) is used to connect to my private network in case I need access to any of my internal services.

Source code formatting is taken care of by [treefmt](https://github.com/numtide/treefmt) and is enforced using [pre-commit](https://pre-commit.com/) which is configured using [cachix/pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix).

But other than that there isn't much here - it's intended to be as empty as possible while still making it easy to play around with new tools or build things.

Credit goes to [Geoffrey Huntley](https://ghuntley.com/) for the idea of [/new](https://ghuntley.com/slash-new/) and the original code in [ghuntley/new](https://github.com/ghuntley/new) which I used as a starting point.

## TODOs

Before switching to nix (merging this branch) I want to

- Figure out how to use some of the built in pre-commit hooks like end-of-file-fixer
- Document shell.nix better
- Version locking (forgot the name of the tool)
- Do I want to use cachix as a binary cache? Is it useful when I don't nix-build anything?

## Notes

### Not using `workspace-full`

Mainly for aesthetics reasons (I just need enough to run Nix, not the full kitchen sink) and as a learning exercise.

### Not using a Gitpod `init` task

Populating the Nix store with all the packages that are required by `shell.nix` is the kind of task that fits really nicely with [Gitpod Prebuilds](https://www.gitpod.io/docs/prebuilds). However, currently prebuilds only save files in the `/workspace` directory ([see docs](https://www.gitpod.io/docs/prebuilds#workspace-directory-only)) and I couldn't get Nix to use `/workspace/nix/store` as the location of the Nix store, so for now, using an `init` task to populate the store isn't possible.

Instead I populate the Nix store in the Dockerfile by `COPY`ing in shell.nix and running `nix-shell --run "exit 0"`.

### Using `cachix/pre-commit-hooks.nix`

I decided to use [cachix/pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix) to manage `.pre-commit-config.yaml` as I want Nix to be in full control of the environment (e.g. usually `pre-commit install` would install all executables required to run the hooks).

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
