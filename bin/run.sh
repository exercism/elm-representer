#!/usr/bin/env sh

set -e # Make script exit when a command fail.
set -u # Exit on usage of undeclared variable.
# set -x # Trace what gets executed.

SLUG="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"

# Normalize identifiers and remove comments
ELM_FILES=$(ls "${INPUT_DIR}"/src/*.elm)
ELM_FILE_COUNT=$(ls "${INPUT_DIR}"/src/*.elm | wc -l)
if [ $ELM_FILE_COUNT == 0 ]; then
    echo "No .elm file found"
    exit -1
elif [ $ELM_FILE_COUNT -gt 1 ]; then
    echo "Multiple .elm files found: ${ELM_FILES}"
    exit -2
fi

ELM_FILEPATH="${ELM_FILES}"
ELM_REPRESENTATION_FILEPATH="${INPUT_DIR}/src/Representation.elm"
REPRESENTATION_FILEPATH="${OUTPUT_DIR}/representation.txt"
MAPPING_FILEPATH="${OUTPUT_DIR}/mapping.json"

echo "Normalizing identifiers in ${ELM_FILES}"
# This also creates the mapping.json file
cat "${ELM_FILES}" | node ./bin/cli.js "${MAPPING_FILEPATH}" > "${ELM_REPRESENTATION_FILEPATH}"

echo "Running elm-format"
./bin/elm-format "${ELM_REPRESENTATION_FILEPATH}" --yes

echo "Creating representation.txt"
mv "${ELM_REPRESENTATION_FILEPATH}" "${REPRESENTATION_FILEPATH}"

echo Finished
