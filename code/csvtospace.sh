 #!/usr/bin/env bash
# Author: Jialuo Wang
# Script: csvtospace.sh
# Description: Convert commas to spaces while preserving empty fields.
# Usage: bash csvtospace.sh input_file
# Date: October 2026

if [ "$#" -ne 1 ]; then
    echo "Error: please provide exactly one input file." >&2
    echo "Usage: bash csvtospace.sh input_file" >&2
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ] || [ ! -r "$input_file" ]; then
    echo "Error: input must be a readable regular file: $input_file" >&2
    exit 1
fi
output_file="../results/$(basename "$input_file").txt"

if ! mkdir -p ../results; then
    echo "Error: could not create the results directory." >&2
    exit 1
fi
if ! tr ',' ' ' < "$input_file" > "$output_file"; then
    echo "Error: conversion failed." >&2
    exit 1
fi

echo "Done: $output_file"
exit 0