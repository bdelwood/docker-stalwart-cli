# Minimal image packaging the Stalwart management CLI (stalwart-cli) 
ARG VERSION=v1.0.8

FROM alpine:3.20 AS build
ARG VERSION
ARG ARCH=x86_64-unknown-linux-musl
RUN apk add --no-cache curl xz \
 && cd /tmp \
 && curl -fsSLO "https://github.com/stalwartlabs/cli/releases/download/${VERSION}/stalwart-cli-${ARCH}.tar.xz" \
 && echo "$(curl -fsSL "https://github.com/stalwartlabs/cli/releases/download/${VERSION}/stalwart-cli-${ARCH}.tar.xz.sha256" | awk '{print $1}')  stalwart-cli-${ARCH}.tar.xz" | sha256sum -c - \
 && tar -xJf "stalwart-cli-${ARCH}.tar.xz" --strip-components=1 -C /usr/local/bin "stalwart-cli-${ARCH}/stalwart-cli" \
 && chmod +x /usr/local/bin/stalwart-cli

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=build /usr/local/bin/stalwart-cli /usr/local/bin/stalwart-cli
ENTRYPOINT ["stalwart-cli"]
