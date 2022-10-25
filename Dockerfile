# Base
FROM alpine:3.16.2 as base
FROM base as builder

## Libs
RUN apk add --no-cache gcc
RUN apk add --no-cache g++
RUN apk add --no-cache python3
RUN apk add --no-cache curl
RUN apk add --no-cache git
RUN apk add --no-cache openssh

## rust

RUN curl -y --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## workspace
RUN mkdir -p /workspace
WORKDIR /workspace

## repo tool
RUN mkdir -p /root/.bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /root/.bin/repo
RUN chmod a+rx /root/.bin/repo
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /root/.bin/repo /usr/bin/repo


# ENTRYPOINT ["sh", "/workspace/builder.sh"]
