FROM ubuntu:24.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl xz-utils

# Preinstall n
RUN apt-get install -y nodejs npm && \
    npm install --global n

# Preinstall uv
# /root/.local/bin/uv,uvx
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Preinstall hadolint
RUN curl -Lo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 && \
    chmod 755 /usr/local/bin/hadolint

# Preinstall shfmt
RUN curl -Lo /usr/local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_linux_amd64 && \
    chmod 755 /usr/local/bin/shfmt

# Preinstall shellcheck
RUN curl -Lo shellcheck.tar.xz https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz && \
    tar -xf shellcheck.tar.xz && \
    cp shellcheck-v0.10.0/shellcheck /usr/local/bin/shellcheck


# ----------------------------------------------------------------------------------------------------
FROM ubuntu:24.04

ARG NODE_VERSION="22.11.0"

WORKDIR /opt/mytools
COPY . /opt/mytools

ENV PATH=/opt/mytools/.venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=builder /usr/local/bin/n /usr/local/bin/n
COPY --from=builder /root/.local/bin/uv /usr/local/bin/
COPY --from=builder /root/.local/bin/uvx /usr/local/bin/
COPY --from=builder /usr/local/bin/hadolint /usr/local/bin/hadolint
COPY --from=builder /usr/local/bin/shfmt /usr/local/bin/shfmt
COPY --from=builder /usr/local/bin/shellcheck /usr/local/bin/shellcheck


RUN apt-get update && \
    apt-get install -y curl neovim git make

RUN n ${NODE_VERSION} && \
    npm install -g ls-lint prettier

RUN uv sync
