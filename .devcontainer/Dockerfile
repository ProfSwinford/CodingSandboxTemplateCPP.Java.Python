# Multi-language sandbox: C++, Java and Python.
#
# Base: Ubuntu 24.04 LTS from the Dev Containers project, which already has a
# non-root "vscode" user, git, curl and sudo set up.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Build-time only, so students still get normal apt prompts later.
ARG DEBIAN_FRONTEND=noninteractive

# C++    -> g++, make, gdb        (build-essential pulls in make + libstdc++)
# Java   -> OpenJDK 21 (JDK, for javac and jdb)
# Python -> python3, pip, venv, and "python" as an alias for "python3"
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      gdb \
      openjdk-21-jdk \
      python3 \
      python3-pip \
      python3-venv \
      python3-dev \
      python-is-python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# JAVA_HOME resolved from the real javac location, so this works unchanged on
# both amd64 and arm64 hosts.
RUN JDK_DIR="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")" \
 && ln -sfn "$JDK_DIR" /usr/lib/jvm/current \
 && printf 'export JAVA_HOME=/usr/lib/jvm/current\n' > /etc/profile.d/10-java-home.sh
ENV JAVA_HOME=/usr/lib/jvm/current

# pip --user installs land in ~/.local/bin.
ENV PATH=/home/vscode/.local/bin:${PATH}
