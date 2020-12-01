#!/usr/bin/env bash

# Example:
# bin/run.sh pangram ~/exercism/elm/pangram .

set -e # Make script exit when a command fail.
set -u # Exit on usage of undeclared variable.
# set -x # Trace what gets executed.
set -o pipefail # Catch failures in pipes.

USAGE="bin/run.sh <exercise-slug> <exercise_directory> <output_directory>"

# If arguments not provided, print usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $USAGE"
    exit 1
fi

EXERCISE_SLUG="$1"
EXERCISE_DIR=$(readlink -f $2)
OUTPUT_DIR=$(readlink -f $3)

echo "Copying exercise files into $OUTPUT_DIR"
cp -r $EXERCISE_DIR/* $OUTPUT_DIR

echo "Running elm-format"
elm-format $OUTPUT_DIR --yes

echo Finished
