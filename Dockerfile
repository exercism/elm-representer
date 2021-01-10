# elm-format doesn't work on node:lts-alpine or node:lts
FROM node:lts-buster-slim AS builder

# Working directory as specified by exercism
WORKDIR /opt/representer

# Install curl to download executables
RUN apt update && apt install -y curl

# Create a directory for binaries
RUN mkdir bin
ENV PATH="/opt/representer/bin:${PATH}"

# Install elm-format
RUN curl -L -o elm-format.tgz https://github.com/avh4/elm-format/releases/download/0.8.4/elm-format-0.8.4-linux-x64.tgz \
  && tar xf elm-format.tgz \
  && mv elm-format bin

# Install elm-strip-comments
RUN curl -L -o elm-strip-comments.tar.gz https://github.com/mpizenberg/elm-strip-comments/releases/download/v0.1.1/elm-strip-comments_linux.tar.gz \
  && tar xf elm-strip-comments.tar.gz \
  && mv elm-strip-comments bin

# Pack together things to copy to the runner container
COPY bin/run.sh bin/run.sh

# Lightweight runner container
FROM node:lts-buster-slim
WORKDIR /opt/representer
COPY --from=builder /opt/representer/bin bin
ENTRYPOINT [ "bin/run.sh" ]
