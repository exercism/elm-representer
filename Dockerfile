FROM node:lts-alpine AS builder

# Working directory as specified by exercism
WORKDIR /opt/representer

# Create a directory for binaries
RUN mkdir bin
ENV PATH="/opt/representer/bin:${PATH}"
ENV ELM_HOME="/opt/representer/elm_home"

# Install elm and elm-format
COPY package.json package-lock.json elm-tooling.json ./
RUN npm ci \
  # Copy elm-format to bin/ to be able to use it in the lightweight runner container
  && cp elm_home/elm-tooling/elm-format/0.8.5/elm-format bin/

# Compile the elm code for the representer
COPY src/*.elm src/
COPY elm.json ./
RUN npm run make && cp src/main.js bin/

# Pack together things to copy to the runner container into bin/
COPY bin/run.sh src/cli.js bin/

# Lightweight runner container
FROM node:lts-alpine
WORKDIR /opt/representer
COPY --from=builder /opt/representer/bin bin
ENTRYPOINT [ "bin/run.sh" ]
