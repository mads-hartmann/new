FROM ubuntu:22.04

# Install minimal set of base system requirments
#
# I also want to install what is needed to bootstrap a Nix environment, the rest
# will be installed and controlled by nix.
#
RUN apt update \
    && apt upgrade \
    && apt-get install -y \
        # I shouldn't need sudo, but doesn't hurt to have it
        sudo \
        # Needed to download nix install script, and by nix itself to download binary tarballs
        curl \
        # needed by Nix to unpack binary tarballs
        xz-utils

# Create the Gitpod user
#
# 
#
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
USER gitpod

# Install nix
#
# I'm using a single-user installation of Nix (hence the --no-daemon).
# While the multi-user installation provides better security, it add additional
# complexity which I don't think is warrented when running in an ephemeral Gitpod workspace
#
RUN curl https://nixos.org/releases/nix/nix-2.11.0/install -o install-nix \
    && chmod +x ./install-nix \
    && ./install-nix --no-daemon \
    && rm ./install-nix
