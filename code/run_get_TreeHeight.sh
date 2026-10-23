#!/bin/bash

# Stop if a command fails.
set -e

# Run from the repository root.
Rscript code/get_TreeHeight.R data/trees.csv
