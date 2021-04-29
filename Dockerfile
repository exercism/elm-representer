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

# Pack together things to copy to the runner container
COPY bin/run.sh bin/run.sh
COPY src/cli.js bin/cli.js
# elm make must have been run to create / update main.js before the container is created
COPY src/main.js bin/main.js

# Lightweight runner container
FROM node:lts-buster-slim
WORKDIR /opt/representer
COPY --from=builder /opt/representer/bin bin
ENTRYPOINT [ "bin/run.sh" ]
