# Boot Camp Coursework

Author: Jialuo Wang

## Files

- `code/unixPrac1.txt`: Commands and explanations for the FASTA exercises.
- `code/tabtocsv.sh`: Replaces tabs with commas.
- `code/csvtospace.sh`: Replaces commas with spaces.
- `data/fasta/`: FASTA input files.
- `data/temperatures/`: Input data for 1800–1803.
- `results/`: Generated outputs, excluded from Git using .gitignore.

## Usage

Start from the repository root and enter the code directory:

```bash
cd code
```

Convert a tab-delimited file, replacing the example path with an actual input path:

```bash
bash tabtocsv.sh "path/to/input_file"
```

Convert a temperature data file:

```bash
bash csvtospace.sh ../data/temperatures/1800.csv
```

Convert all four temperature data files:

```bash
for input_file in ../data/temperatures/*.csv; do
    bash csvtospace.sh "$input_file"
done
```

Run these scripts from the code directory.
Outputs are saved in ../results/.
tabtocsv.sh appends .csv to the original filename.
csvtospace.sh appends .txt to the original filename.
Repeated runs overwrite the corresponding output file.

## Dependencies

Bash and standard command-line utilities, including tr, basename and mkdir.
The FASTA exercises also use wc, tail, grep and bc.

## Testing Completed

- Both scripts passed syntax checks using bash -n.
- Both scripts were tested with filenames containing spaces and data containing empty fields.
- Repeated runs overwrote outputs without appending duplicate content.
- csvtospace.sh successfully converted all four temperature data files.
- csvtospace.sh returned exit status 1 when no argument was supplied or the input file did not exist.

## Limitations

Both scripts perform character replacement rather than full CSV parsing.
csvtospace.sh does not support complex CSV files containing commas inside quoted fields or embedded newlines.
Spaces within field values may make field boundaries ambiguous after conversion.

## AI Assistance

ChatGPT was used to help explain Shell commands,
design tests and prepare documentation.
Commands and scripts were run locally, and their outputs were checked.


## Assignment 2: Tree-survey validation

### Input
- `data/silwood_trees_raw.csv`
- Validation rules: `data/silwood_trees_metadata.md`

### Planned outputs
- `results/silwood_trees_clean.csv`: accepted and cleaned records.
- `results/silwood_tree_issues.csv`: rejected records and their reasons.
- `results/oak_species_counts.csv`: accepted oak counts by species.

### Algorithm plan
```text
Read the original CSV without modifying it.
Create collections for accepted records, issues and accepted identifiers.

For each record in input order:
    Clean text using only the permitted rules.
    Check required values, identifiers, taxa and measurements.
    Collect all applicable rejection reasons in the required order.
    If any reasons exist:
        Record the source row, identifier and reasons.
    Otherwise:
        Accept the cleaned record and reserve its identifier.

Sort accepted records by identifier.
Count accepted Quercus records by species.
Sort the oak summary by species.
Write the three output CSV files, replacing previous outputs.
```
### Running and testing

Run these commands from the project root:

```bash
python3 code/clean_silwood_trees.py
python3 code/test_silwood_trees.py
```

The program creates `results/` if needed and replaces the three output files.
The supplied survey produces 24 accepted records and 12 rejected records.
The oak summary contains four `petraea` records and four `robur` records.

### Validation checks

Tests cover text cleaning, missing and unrecognised values, invalid
taxon combinations, numeric boundaries, non-finite numbers, duplicate
identifiers, multiple rejection reasons and oak summaries.

One useful test checks that a rejected record does not reserve its
identifier. This detects implementations that incorrectly reject a later
valid record with the same identifier.

Additional checks confirmed that importing the module does not perform
file operations or print output, repeated runs produce identical files,
and the raw input remains unchanged during execution.

### Assistance used

I used ChatGPT for step-by-step explanations, implementation and test
examples, and help diagnosing code placement and indentation errors.

### Limitations

The program follows the supplied metadata and permitted values.
It does not infer missing values or correct unrecognised spellings.
It expects the specified CSV columns and string-valued fields.