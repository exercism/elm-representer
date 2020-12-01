# elm-format doesn't work on node:lts-alpine or node:lts
FROM node:lts-buster

# Working directory as specified by exercism
RUN mkdir /opt/representer
RUN mkdir /opt/representer/bin
WORKDIR /opt/representer

# node best practices https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#global-npm-dependencies
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
USER node
RUN npm install elm-format -g

COPY ./bin/run.sh ./bin/run.sh
COPY ./bin/elm-format ./bin/elm-format

ENTRYPOINT [ "bash", "./bin/run.sh" ]
# ENTRYPOINT sleep 600
