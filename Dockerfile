# Base
FROM debian:stable-slim as base
FROM base as builder

# workspace
RUN mkdir -p /workspace
WORKDIR /workspace

## Libs
RUN apt-get update
RUN apt-get install -y curl 
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y python3-pip
RUN apt-get install -y cmake
RUN apt-get install -y ninja-build

## rust
RUN curl \
    --proto '=https' \
    --tlsv1.2 \
    -sSf https://sh.rustup.rs | sh -s -- -y
RUN ln -s /root/.cargo/bin/cargo /usr/bin/cargo
RUN ln -s /root/.cargo/bin/rustup /usr/bin/rustup
RUN ln -s /root/.cargo/bin/rustc /usr/bin/rustc

## repo tool
RUN mkdir -p /root/.bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /root/.bin/repo
RUN chmod a+rx /root/.bin/repo
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /root/.bin/repo /usr/bin/repo

## python libs
RUN pip3 install --upgrade pip
RUN pip3 install \
    --no-cache-dir \
    --user \
    tempita
RUN pip3 install \
    --no-cache-dir \
    --user \
    camkes-deps

## rust libs
RUN rustup toolchain add nightly-2021-11-05
RUN rustup toolchain add nightly-aarch64-unknown-linux-gnu
RUN rustup target add --toolchain \
    nightly-2021-11-05-x86_64-unknown-linux-gnu \
    aarch64-unknown-none

### cmake deps
RUN apt-get install -y binutils-aarch64-linux-gnu
RUN apt-get install -y gcc-aarch64-linux-gnu
RUN apt-get install -y g++-aarch64-linux-gnu

## Clean 
# RUN apt-get autoremove -y
# RUN rm -rf /var/lib/apt/lists/*

# Runtime ENV
## Python lib PATH
RUN echo "export PATH=/root/.local/bin:\$PATH" >> /root/.profile

# ENTRYPOINT ["sh", "/workspace/builder.sh"]
