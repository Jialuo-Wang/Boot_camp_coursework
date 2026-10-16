# Assignment 1 feedback - Jialuo Wang

**Formative feedback | Rubric 2026.2**

The README is a useful part of this submission: it explains usage, dependencies, tests and the limits of simple character substitution. All five FASTA answers matched the independent checks, and the converter sources have consistent validation and conversion-error handling.

The principal correction is where the converter outputs go. Both scripts use ../results, which is consistent with each other but assumes execution inside code/. They should work from the repository root and write into that repository's results directory. Revise the examples at the same time, then check the actual output from a clean checkout.

Add the required data/tab-example.tsv. A small table with an empty field will give you a much more useful check than relying only on a large supplied file. Try it with a spaced filename and a second run, and record both the expected contents and what you observed. The leading space before the CSV script's shebang should also be removed for direct execution; it was not the cause of the Bash-invoked assessment results.

The current history contains only one greeting-style commit. That does not tell us that no earlier work happened, but it does not show incremental, descriptive version control either. Make the next changes in focused commits that say what was corrected. Keep the existing results ignore rule and the substantial README, adding the missing date to the assistance record.

---

## Project structure

Relevant tracked layout (simplified; missing required paths are marked):

```text
README.md
.gitignore
code/  unixPrac1.txt, tabtocsv.sh, csvtospace.sh
data/fasta/  3 required files present
data/temperatures/  4 required files present
data/tab-example.tsv [missing]
results/  no files tracked; generated on run
sandbox/  no files tracked; optional
```

The root README and ignore file, assessed code and supplied FASTA/temperature inputs are present. The required own TSV is missing. No generated outputs are tracked, and results/ is explicitly ignored, so its absence from the tracked tree is appropriate.

Add data/tab-example.tsv and retain the clean separation of source and generated files. The scripts should create results/ at run time. Keep the README's file map, but update its converter commands to work with the root layout rather than relying on an existing code/-based terminal session.

**Assessed snapshot:** `009a016374f9d0132116ff8df308596b45bd5741`
