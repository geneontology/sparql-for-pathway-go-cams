#!/bin/bash

MODEL_LIST=$1
NOCTUA_MODELS_DIR=$2
DEST_DIR=$3

# Loop through each line in the input file
while IFS=$'\t' read -r url _; do
    if [[ "$url" == \?gocam* ]]; then
        continue
    fi

    # Extract the trailing ID from the URL
    id=$(basename "$url" | sed 's/gomodel://')
    # Copy the corresponding .ttl file to the selected directory
    echo "cp $NOCTUA_MODELS_DIR/models/$id.ttl" "$DEST_DIR/"
    cp "$NOCTUA_MODELS_DIR/models/$id.ttl" "$DEST_DIR/"
done < "$MODEL_LIST"
