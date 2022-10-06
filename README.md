# `new`

This is my starting point for _new_ things; it's my ["dotfiles" but "for computers"](https://ghuntley.com/slash-new/).

It uses [nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html) to provide a [declarative and reproducible developer environment](https://nix.dev/tutorials/declarative-and-reproducible-developer-environments) and is meant to be run in [Gitpod](https://gitpod.io/).

[Tailscale](https://tailscale.com/) is used to connect to my private network in case I need access to any of my internal services.

Source code formatting is taken care of by [treefmt](https://github.com/numtide/treefmt) and is enforced using [pre-commit](https://pre-commit.com/) which is configured using [cachix/pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix).

[nmattia/niv](https://github.com/nmattia/niv) is used to manage Nix dependencies and they're automatically updated every night through the use of [niv-updater-action](https://github.com/marketplace/actions/niv-updater-action) - see [.github/workflows/niv-updater.yaml](.github/workflows/niv-updater.yaml).

But other than that there isn't much here - it's intended to be as empty as possible while still making it easy to play around with new tools or build things.

Credit goes to [Geoffrey Huntley](https://ghuntley.com/) for the idea of [/new](https://ghuntley.com/slash-new/) and the original code in [ghuntley/new](https://github.com/ghuntley/new) which I used as a starting point.

## Decisions

### Using `niv` to manage dependencies

I'm using [nmattia/niv](https://github.com/nmattia/niv) to manage Nix dependencies in this project. Even though I don't have a lot of dependencies to manage I still decided to use it due to the convenience it provides when it comes to updating dependencies.

### Not using `workspace-full`

Mainly for aesthetics reasons. I want to use Nix to manage the environment and I find it tidier if the environment that isn't controlled by Nix is as minimal as possible.

Additionally, I haven't used Nix before, understanding what the minimal system requirements are was a fun exercise.

### Not using a Gitpod `init` task

Populating the Nix store with all the packages that are required by `shell.nix` is the kind of task that fits really nicely with [Gitpod Prebuilds](https://www.gitpod.io/docs/prebuilds). However, currently prebuilds only save files in the `/workspace` directory ([see docs](https://www.gitpod.io/docs/prebuilds#workspace-directory-only)) and I couldn't get Nix to use `/workspace/nix/store` as the location of the Nix store, so for now, using an `init` task to populate the store isn't possible.

Instead I populate the Nix store in the Dockerfile by `COPY`ing in shell.nix and running `nix-shell --run "exit 0"`. This does have the downside that I have to manually bump an ENV in the Dockerfile to trigger new builds. It's not too bad - if I forget it simply means that my workspace will have to populate the Nix store with the missing packages when it starts.

### Not using direnv

[direnv](https://direnv.net/) is a neat way to have folders-specific shell environments which integrates really nicely with nix-shell. I decided against including it in this repository as it requires a bit of additional setup and I don't have any concrete use-case for it in this tiny repository.

<details>
  <summary>However, if I wanted to add it again here's how to do it</summary>

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

</details>

### Using `cachix/pre-commit-hooks.nix`

I decided to use [cachix/pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix) to manage `.pre-commit-config.yaml` as I want Nix to be in full control of the environment. Normally `pre-commit install` would install all the executables required to run the hooks, which would then not be managed by Nix.

The downside of this is that it's a bit more complicated to use existing hooks, e.g. the ones that are part of [pre-commit/pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks). As you can see in my `shell.nix` it means you have to duplicate the hook settings. For more context [this comment](https://github.com/cachix/pre-commit-hooks.nix/issues/31#issuecomment-744657870) in [cachix/pre-commit-hooks.nix/issues/31](https://github.com/cachix/pre-commit-hooks.nix/issues/31).

### Not using cachix as a binary cache

A lot of Nix examples out there use [Cachix](https://www.cachix.org/). My understanding so far is that it's mainly useful if you use Nix to build your applications and what to share a build cache "between CI, development and deployment environments.".
