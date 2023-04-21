FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG TARGETARCH
ARG OS=linux

LABEL maintainer="Jan Untersander, Tsigereda Nebai Kidane"

# Setting locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install common tools
RUN apt-get update && apt-get install -y \
    build-essential \
    bash-completion \
    curl \
    vim \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ENV GO_VERSION 1.20.1

RUN wget -q https://golang.org/dl/go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz \
    && rm go${GO_VERSION}.${OS}-${TARGETARCH}.tar.gz
ENV PATH $PATH:/usr/local/go/bin

# Install Operator SDK
ENV OPERATOR_SDK_VERSION v1.28.0
RUN curl -LO https://github.com/operator-framework/operator-sdk/releases/download/${OPERATOR_SDK_VERSION}/operator-sdk_${OS}_${TARGETARCH} \
    && chmod +x operator-sdk_${OS}_${TARGETARCH} \
    && mv operator-sdk_${OS}_${TARGETARCH} /usr/local/bin/operator-sdk \
    && echo $(operator-sdk version)

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

# Install Okteto
ENV OKTETO_VERSION 2.13.0
RUN curl https://get.okteto.com -sSfL | sh -

# Install mkdocs
RUN pip3 install mkdocs mkdocs-material pymdown-extensions mkdocs-exclude mkdocstrings[crystal,python] mkdocs-monorepo-plugin mkdocs-print-site-plugin mkdocs-awesome-pages-plugin mkdocs-glightbox

# Install fzf completion
COPY fzf-completion.bash /usr/share/bash-completion/fzf-completion.bash
COPY fzf-key-bindings.bash /usr/share/bash-completion/fzf-key-bindings.bash

# Add completion
COPY docker-completion.bash /usr/share/bash-completion/docker-completion.bash
COPY .bash_config /home/vscode/.bash_config
RUN echo "source ~/.bash_config" >> /home/vscode/.bashrc

WORKDIR /workspace
RUN chown vscode:vscode /workspace
VOLUME ["/workspace"]

USER vscode

# Install krew
RUN <<EOF
#!/bin/bash
(set -x; cd "$(mktemp -d)" && \
OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
KREW="krew-${OS}_${ARCH}" &&\
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&\
tar zxvf "${KREW}.tar.gz" && \
./"${KREW}" install krew)
EOF
ENV PATH "${KREW_ROOT:-/home/vscode/.krew}/bin:${PATH}"

# Install kubectx and kubens
RUN <<EOF
#!/bin/bash
kubectl krew install ctx ns
EOF

# Install k9s
RUN curl -sS https://webinstall.dev/k9s | bash

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/vscode/.fzf \
    && /home/vscode/.fzf/install --all
