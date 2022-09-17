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
