Before switching to nix (merging this branch) I want to

- Document the various bits in shell.nix
- Document some of the things in the Dockerfile
- Document .envrc
- [x] Clean up the .gitpod.yml so I don't get that many shells
- Run treefmt as a git hook

- [ ] Right now git isn't installed in the workspace image which confuses vs-code Source Control. How do I tell vs-code that it should use my nix-shell?

- Get rid of "direnv: error /workspace/new/.envrc is blocked. Run `direnv allow` to approve its content" errors the Gitpod tasks (scroll alll the way up to see them)
