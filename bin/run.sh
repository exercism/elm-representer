#!/bin/sh

set -e # Make script exit when a command fail.
set -u # Exit on usage of undeclared variable.
# set -x # Trace what gets executed.

# Command line arguments
SLUG="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"

# Setup a working directory
WORK_DIR=/opt/representer/app
cp -rp $INPUT_DIR $WORK_DIR

# Add bin/ to the path to make available installed executables
export PATH=/opt/representer/bin:${PATH}

# Removing comments
echo "Removing comments"
cd $WORK_DIR/src
rm -f *.example.elm # for practice
elm-strip-comments --replace *.elm

# Running elm-format
echo "Running elm-format"
elm-format *.elm --yes

# Move normalized representation to output dir
echo "Creating representation.txt"
cat *.elm > $OUTPUT_DIR/representation.txt

# Create the mapping for placeholders
echo "Creating mapping.json"
echo "{}" > $OUTPUT_DIR/mapping.json

echo Finished
