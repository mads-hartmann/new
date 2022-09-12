Before switching to nix (merging this branch) I want to

- Document the various bits in shell.nix
- Document some of the things in the Dockerfile
- Document .envrc
- [x] Clean up the .gitpod.yml so I don't get that many shells
- Run treefmt as a git hook

- Get rid of "direnv: error /workspace/new/.envrc is blocked. Run `direnv allow` to approve its content" errors the Gitpod tasks (scroll alll the way up to see them)
  This is because they tasks use the Gitpod users shell profile
