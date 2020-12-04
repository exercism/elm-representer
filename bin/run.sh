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

echo "Removing comments"
pushd $OUTPUT_DIR/src/
cloc --strip-comments=nocomments *.elm
rm *.elm
for f in *.nocomments; do 
    mv -- "$f" "${f%.nocomments}"
done
popd

echo "Running elm-format"
elm-format $OUTPUT_DIR --yes

echo creating representation.txt
cat $OUTPUT_DIR/src/*.elm > $OUTPUT_DIR/representation.txt

echo creating mapping.json
echo {} > $OUTPUT_DIR/mapping.json


echo Finished
