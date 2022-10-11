# TODOs

- Enable auto-merge for PRs<br/>
  I'd like to use something like [peter-evans/enable-pull-request-automerge](https://github.com/peter-evans/enable-pull-request-automerge) to ensure that my Niv update PRs are automatically merged. Before doing so, I want to enable branch protection, and add a minimal CI check to my build.
- Version locking<br/>
  So far I just pinned the version following [this guide](https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs). I might want to use [niv](https://github.com/nmattia/niv) though. I'd also like to figure out what mechanisms are in place for pinning a specific tool to a specific version. [This issue](https://github.com/NixOS/nixpkgs/issues/93327) might help me understand if that's possible and if so, how.
  [This](https://lazamar.co.uk/nix-versions/) is also an interesting help you find specific versions of tools
- Consider not using `cachix/pre-commit-hooks.nix` and instead vanilla pre-commit-hooks and wrap any custom hooks like fmt with depot
- Use https://github.com/pascalgn/automerge-action to auto-merge the PRs created by my niv-updater action
