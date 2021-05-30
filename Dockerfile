# elm-format doesn't work on node:lts-alpine or node:lts
FROM node:lts-buster-slim AS builder

# Working directory as specified by exercism
WORKDIR /opt/elm-representer

# Create a directory for binaries
RUN mkdir bin
ENV PATH="/opt/elm-representer/bin:${PATH}"
ENV ELM_HOME="/opt/elm-representer/elm_home"

# Install elm and elm-format
COPY package.json package-lock.json elm-tooling.json ./
RUN npm ci \
  # Copy elm-format to bin/ to be able to use it in the lightweight runner container
  && cp elm_home/elm-tooling/elm-format/0.8.5/elm-format bin/

# Compile the elm code for the representer
RUN apt update && apt -y install ca-certificates
COPY src/*.elm src/
COPY elm.json ./
RUN npm run make

# Pack together things to copy to the runner container into bin/
COPY bin/run.sh src/cli.js src/main.js bin/

# Lightweight runner container
FROM node:lts-buster-slim
WORKDIR /opt/elm-representer
COPY --from=builder /opt/elm-representer/bin bin
ENTRYPOINT [ "bin/run.sh" ]
