ARG OS_FAMILY=debian
ARG OS_TAG=unstable-slim
FROM $OS_FAMILY:$OS_TAG

ENV DEBIAN_FRONTEND="noninteractive"
ARG APT_PKGS="\
    build-essential \
    cmake \
    git \
    jq \
    ninja-build \
    python3.10 \
    python3.10-dev \
    python3-distutils \
    python3-setuptools \
    wget"

RUN apt-get update \
    && apt-get install -y -qq $APT_PKGS \
    && mkdir -p /usr/local/lib/bazel/bin \
    && cd "/usr/local/lib/bazel/bin" \
    && wget -q https://releases.bazel.build/5.0.0/release/bazel-5.0.0-linux-x86_64 \
    && chmod +x bazel-5.0.0-linux-x86_64 \
    && cp -a bazel-5.0.0-linux-x86_64 /usr/bin/bazel \
    && git config --global --add safe.directory /src/workspace/envoy \
    && mkdir -p /src/workspace \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*
