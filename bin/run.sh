#!/bin/bash

set -e # Make script exit when a command fail.
set -u # Exit on usage of undeclared variable.
# set -x # Trace what gets executed.

SLUG="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"

# Normalize identifiers and remove comments
ELM_FILES=("$INPUT_DIR"/*.elm)
if [ ${#ELM_FILES[@]} == 0 ]; then
    echo "No .elm file found (${ELM_FILES[@]})"
    exit -1
elif [ ${#ELM_FILES[@]} -gt 1 ]; then  
    echo "Multiple .elm files found (${ELM_FILES[@]})"
    exit -2
fi
ELM_FILEPATH=${ELM_FILES[0]}
ELM_FILENAME="$(basename $ELM_FILEPATH)"

echo "Normalizing identifiers in ${OUTPUT_DIR}${ELM_FILENAME}"
# This also creates the mapping.json file
cat $ELM_FILEPATH | node ./bin/cli.js ${OUTPUT_DIR}mapping.json > ${OUTPUT_DIR}${ELM_FILENAME}

echo "Running elm-format"
./bin/elm-format $OUTPUT_DIR --yes

echo "Creating representation.txt"
cat $OUTPUT_DIR/$ELM_FILENAME > $OUTPUT_DIR/representation.txt

echo Finished
