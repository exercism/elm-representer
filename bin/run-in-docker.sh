#!/usr/bin/env bash

# Synopsis:
# Test runner for run.sh in a docker container
# Builds the Dockerfile
# Runs the docker image passing along the initial arguments

# Arguments:
# Should be run at the root of the repo (in same folder as the Dockerfile)
# $1: exercise slug
# $2: absolute path to solution folder (with trailing slash)
# $3: absolute path to output directory (with trailing slash)

# Output:
# Writes the normalized code to representation.txt in output directory.
# Writes the identifier mappings to mappings.json in output directory.

# Example:
# ./bin/run-in-docker.sh bob /PathToThisRepo/example-bob-solution/ /PathToThisRepo/example-output/

set -e # Make script exit when a command fail.
set -u # Exit on usage of undeclared variable.
set -o pipefail # Catch failures in pipes.

USAGE="bin/run-in-docker.sh <exercise-slug> /path/to/solution-folder/ /path/to/output-directory/"

# If arguments not provided, print usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $USAGE"
    exit 1
fi

SLUG="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"

docker build -t elm-representer .

mkdir -p "$OUTPUT_DIR"
docker run --network none \
    --mount type=bind,src=$INPUT_DIR,dst=/solution \
    --mount type=bind,src=$OUTPUT_DIR,dst=/output \
    elm-representer $SLUG /solution/ /output/
