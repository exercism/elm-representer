# Elm Representer

[![ceddlyburge](https://circleci.com/gh/ceddlyburge/elm-representer.svg?style=svg)](https://circleci.com/gh/ceddlyburge/elm-representer)

This outputs a normalized representation of Elm Code, to make automated analysis easier within Exercism.

Thanks to [Elm Platform Worker Example](https://github.com/jxxcarlson/elm-platform-worker-example) for the initial template.

## Install

```bash
npm install
```

## Build

To compile the representer code, you can run `elm make --optimize src/Main.elm --output=src/main.js` in your terminal.
Alternatively, you can simply use the following npm script, configured in the `package.json` file.

```bash
npm run make
```

If the code requires the `Debug` module (which it currently doesn't), use instead `npm run make-debug` that remove the `--optimize` from the command.

## Usage

To normalise a file (bob.elm) and save normalized code to bob-normalized.elm and identifier mapping to mapping.json

```bash
cat bob.elm | node src/cli.js mapping.json > bob-normalized.elm
```

To normalize all the example files in this repo

```bash
sh normalize-examples.sh
```

## Test

```sh
elm-test
```

## Docker

This repo also contains the Docker configuration for integration with Exercism.

To normalise an Exercism solution using a Docker container:

```sh
# Mac / Linux
./bin/run-in-docker.sh bob /PathToThisRepo/example-bob-solution/ /PathToThisRepo/example-output/
```

```ps
# Windows
./bin/run-in-docker.ps1 bob /PathToThisRepo/example-bob-solution/ /PathToThisRepo/example-output/
```
