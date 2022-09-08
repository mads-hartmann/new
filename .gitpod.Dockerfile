FROM gitpod/workspace-base

USER root

# Install Nix
# TOOD: Do we really need these? From the latest install script it sounds like it will create these for us.
# RUN addgroup --system nixbld \
#   && adduser gitpod nixbld \
#   && for i in $(seq 1 30); do useradd -ms /bin/bash nixbld$i &&  adduser nixbld$i nixbld; done \
#   && mkdir -m 0755 /nix && chown gitpod /nix \
#   && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf
RUN mkdir -m 0755 /nix && chown gitpod /nix \
  && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf
  
# Install Nix
CMD /bin/bash -l
USER gitpod
ENV USER gitpod
WORKDIR /home/gitpod

RUN touch .bash_profile \
 && curl https://nixos.org/releases/nix/nix-2.11.0/install | sh

RUN echo '. /home/gitpod/.nix-profile/etc/profile.d/nix.sh' >> /home/gitpod/.bashrc
RUN mkdir -p /home/gitpod/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/gitpod/.config/nixpkgs/config.nix

# Install cachix
RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -iA cachix -f https://cachix.org/api/v1/install \
  && cachix use cachix

# Install git
RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i git git-lfs

# Install direnv
#
# Setting DIRENV_LOG_FORMAT to the empty string means direnv won't output
# any logs when loading the environment. This makes things nice and quiet
# but if you need to debug things, temporarily removing it might be helpful.
RUN . /home/gitpod/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i direnv \
  && direnv hook bash >> /home/gitpod/.bashrc \
  && echo 'export DIRENV_LOG_FORMAT=""' >> /home/gitpod/.bashrc
