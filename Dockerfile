FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG TARGETARCH
ARG OS=linux

LABEL maintainer="Jan Untersander, Tsigereda Nebai Kidane"

ARG DEBIAN_FRONTEND noninteractive

# Install basics
RUN apt-get update -q \
    && apt-get install -qy --no-install-recommends \
    build-essential \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Setting locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Go
ENV GO_VERSION 1.20.1

RUN wget -q https://golang.org/dl/go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz \
    && rm go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz
ENV PATH $PATH:/usr/local/go/bin

# Install Operator SDK
ENV OPERATOR_SDK_VERSION v1.26.1
RUN curl -LO https://github.com/operator-framework/operator-sdk/releases/download/${OPERATOR_SDK_VERSION}/operator-sdk_${OS}${TARGETARCH} \
    && chmod +x operator-sdk_${OS}${TARGETARCH} \
    && mv operator-sdk_${OS}${TARGETARCH} /usr/local/bin/operator-sdk

# Install kubectl
ENV KUBECTL_VERSION v1.26.1
RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${OS}/${TARGETARCH}/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

# Install Helm
ENV HELM_VERSION v3.11.1
RUN curl -LO https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${TARGETARCH}.tar.gz \
    && tar -zxvf helm-${HELM_VERSION}-${OS}-${TARGETARCH}.tar.gz \
    && mv ${OS}-${TARGETARCH}/helm /usr/local/bin/helm \
    && rm -rf helm-${HELM_VERSION}-${OS}-${TARGETARCH}.tar.gz ${OS}-${TARGETARCH}

# Install K0s
ENV K0S_VERSION v1.26.1+k0s.0
RUN curl -sSLF https://get.k0s.sh | sh

WORKDIR /workspace
RUN chown vscode:vscode /workspace
VOLUME ["/workspace"]

USER vscode
