# MIT License
#
# Copyright (c) 2019 Quentin McGaw
# https://github.com/qdm12/basedevcontainer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

ARG UBUNTU_VERSION=bionic

ARG DOCKER_VERSION=v20.10.17
ARG COMPOSE_VERSION=v2.9.0
ARG BUILDX_VERSION=v0.8.2
ARG LOGOLS_VERSION=v1.3.7
ARG BIT_VERSION=v1.1.2
ARG GH_VERSION=v2.14.4
ARG DEVTAINR_VERSION=v0.6.0

FROM qmcgaw/binpot:docker-${DOCKER_VERSION} AS docker
FROM qmcgaw/binpot:compose-${COMPOSE_VERSION} AS compose
FROM qmcgaw/binpot:buildx-${BUILDX_VERSION} AS buildx
FROM qmcgaw/binpot:logo-ls-${LOGOLS_VERSION} AS logo-ls
FROM qmcgaw/binpot:bit-${BIT_VERSION} AS bit
FROM qmcgaw/binpot:gh-${GH_VERSION} AS gh
FROM qmcgaw/devtainr:${DEVTAINR_VERSION} AS devtainr

FROM ubuntu:${UBUNTU_VERSION}
ARG CREATED
ARG COMMIT
ARG VERSION=local
LABEL \
  org.opencontainers.image.authors="mike.k@blu-web.com" \
  org.opencontainers.image.created=$CREATED \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.url="https://github.com/mkell43/devcontainer/basedev" \
  org.opencontainers.image.documentation="https://github.com/mkell43/devcontainer/basedev" \
  org.opencontainers.image.source="https://github.com/mkell43/devcontainer/basedev" \
  org.opencontainers.image.title="Base Dev container Ubuntu" \
  org.opencontainers.image.description="Base Ubuntu development container for Visual Studio Code Remote Containers development"
ENV BASE_VERSION="${VERSION}-${CREATED}-${COMMIT}"

# CA certificates
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates && \
  rm -r /var/cache/* /var/lib/apt/lists/*

# Timezone
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends tzdata && \
  rm -r /var/cache/* /var/lib/apt/lists/*
ENV TZ=

# Setup Git and SSH
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends git git-man man openssh-client less && \
  rm -r /var/cache/* /var/lib/apt/lists/*
COPY .windows.sh /root/
RUN chmod +x /root/.windows.sh

# Setup shell
ENTRYPOINT [ "/bin/zsh" ]
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends zsh nano locales wget && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -r /var/cache/* /var/lib/apt/lists/*
ENV EDITOR=nano \
  LANG=en_US.UTF-8 \
  # MacOS compatibility
  TERM=xterm
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
  locale-gen en_US.UTF-8
RUN usermod --shell /bin/zsh root

RUN git config --global advice.detachedHead false

COPY shell/.zshrc shell/.welcome.sh /root/
RUN git clone --single-branch --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

ARG POWERLEVEL10K_VERSION=v1.16.1
COPY shell/.p10k.zsh /root/
RUN git clone --branch ${POWERLEVEL10K_VERSION} --single-branch --depth 1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && \
  rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k/.git

RUN git config --global advice.detachedHead true

# Docker CLI
COPY --from=docker /bin /usr/local/bin/docker
ENV DOCKER_BUILDKIT=1

# Docker compose
COPY --from=compose /bin /usr/libexec/docker/cli-plugins/docker-compose
ENV COMPOSE_DOCKER_CLI_BUILD=1
RUN echo "alias docker-compose='docker compose'" >> /root/.zshrc

# Buildx plugin
COPY --from=buildx /bin /usr/libexec/docker/cli-plugins/docker-buildx

# Logo ls
COPY --from=logo-ls /bin /usr/local/bin/logo-ls
RUN echo "alias ls='logo-ls'" >> /root/.zshrc

# Bit
COPY --from=bit /bin /usr/local/bin/bit
ARG TARGETPLATFORM
RUN if [ "${TARGETPLATFORM}" != "linux/s390x" ]; then echo "y" | bit complete; fi

COPY --from=gh /bin /usr/local/bin/gh

COPY --from=devtainr /devtainr /usr/local/bin/devtainr
