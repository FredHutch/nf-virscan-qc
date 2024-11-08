#!/bin/bash

nextflow run \
    "<PATH_TO_REPO>" \
    -profile docker \
    --input_dir "<INPUT_DIR>" \
    --output_dir "<OUTPUT_DIR>" \
    -resume
