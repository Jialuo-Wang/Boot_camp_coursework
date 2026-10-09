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