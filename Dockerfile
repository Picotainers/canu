# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS builder
ARG CANU_VERSION=2.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN curl -fsSL -o canu.tar.xz \
        "https://github.com/marbl/canu/releases/download/v${CANU_VERSION}/canu-${CANU_VERSION}.Linux-amd64.tar.xz" \
    && tar -xJf canu.tar.xz \
    && rm canu.tar.xz \
    && mv canu-${CANU_VERSION} canu

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        openjdk-17-jre-headless \
        perl \
        procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/canu /opt/canu

ENV PATH="/opt/canu/bin:${PATH}"
WORKDIR /data

ENTRYPOINT ["canu"]
CMD ["--help"]
