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
## Assignment 3: Tree height calculation

### Input and output

- Input: `data/trees.csv` (120 records; kept unchanged).
- Script: `code/TreeHeight.R`.
- Output: `results/TreeHts.csv`.

The script calculates height in metres using:
`height_m = Distance.m * tan(Angle.degrees * pi / 180)`.

It checks the column names, numeric types, finite values, and required
distance and angle ranges. It preserves the original rows and columns,
then appends `height_m` as the fourth column.

### Running

Run from the repository root:

```bash
Rscript code/TreeHeight.R
```

Alternatively, start R from the repository root and run:

```r
source("code/TreeHeight.R")
```

The script creates `results/` if needed and replaces the output on rerun.

### Checks performed

- Confirmed that the output contains 120 records.
- Confirmed that the original three columns and row order are preserved.
- Checked a separate example: distance = 8 m and angle = 45 degrees
  gives height = 8 m.
- Confirmed that running the script twice produces identical output.
- Confirmed that the script works using both Rscript and source().

### Assistance
I used ChatGPT for step-by-step explanations,
code examples, and guidance on checking the output.
### Generalized tree-height script

Run from the repository root with exactly one readable CSV path:

```bash
Rscript code/get_TreeHeight.R data/trees.csv
```

Alternatively, run the supplied-data wrapper:

```bash
bash code/run_get_TreeHeight.sh
```

The wrapper stops if the R command fails.

The input must contain the columns `Species`, `Distance.m`, and
`Angle.degrees` in that order. The script applies the same input checks
and height calculation as `TreeHeight.R`.

Output is written to `results/<input-stem>_treeheights.csv`.
For `data/trees.csv`, this is `results/trees_treeheights.csv`.
The output preserves the original three columns and row order, and
appends `height_m`. Rerunning replaces the output.

The output name uses only the input basename. Inputs in different
directories with the same basename therefore share an output filename.
The script checks that the output path does not overwrite the input.

Checks completed:
- Missing and extra arguments produce a usage error.
- A missing input file produces a clear error.
- An incorrect header is rejected.
- Repeated runs produce identical output, verified using SHA-256 hashes.

For debugging, I temporarily placed `browser()` before the height
calculation and started R with `R --vanilla --args data/trees.csv`.
I inspected the first record and calculated an expected height of
approximately 27.80212 m. After stepping through the calculation,
the calculated value matched the prediction. I then removed `browser()`.

On 23 October 2026, I used ChatGPT for explanations, implementation
examples, and guidance on command-line checks and interactive debugging.
