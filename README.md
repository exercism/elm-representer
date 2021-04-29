# Elm Representer

[![ceddlyburge](https://circleci.com/gh/ceddlyburge/elm-representer.svg?style=svg)](https://circleci.com/gh/ceddlyburge/elm-representer)

This outputs a normalized representation of Elm Code, to make automated analysis easier within Exercism.

Thanks to [Elm Platform Worker Example](https://github.com/jxxcarlson/elm-platform-worker-example) for the initial template.

## Install

```bash
npm install
```

## Build

-d uses debug in `elm make` (required if `Debug` is used in the code, which it isn't at the moment)

```bash
sh make.sh
sh make.sh -d
```

## Usage

To normalise a file (bob.elm) and save normalized code to bob-normalized.elm and identifier mapping to mapping.json

```bash
cat bob.elm | node src/cli.js mapping.jon > bob-normalized.elm
```

To normalize all the example files in this repo

```bash
sh normalize-examples.sh
```

## Test

```
elm-test
```

## TODO Docker 

This repo also contains the Docker manifest for integration with Exercism.

To normalise an Exercism solution using a Docker container:

```sh
# Mac / Linux
bin/run-in-docker.sh <exercise-slug> <exercise-directory> <output-directory>
```

```ps
# Windows
bin/run-in-docker.ps1 <exercise-slug> <exercise-directory> <output-directory>
```
