# Assignment 3 formative feedback

This feedback is organised using the [Computing Bootcamp rubric](https://mulquabio.github.io/MQB/rubrics/Computing_Bootcamp_Rubric.html). It does not award a mark; use it to decide what to revise and check before final submission.

## Criterion 1: Repository organisation & workflow discipline

Before final submission, check that the required scripts are under `code/`, supplied inputs are under `data/`, and generated files remain outside Git.

## Criterion 2: Code completeness & functional correctness

- Both tree-height routes ran separately and produced outputs matching the required tree-height columns and calculated values: `results/TreeHts.csv` and `results/trees_treeheights.csv`. Your code shows the angle-to-radians conversion, appropriately ordered function inputs and validation before calculation and writing.

## Criterion 3: Code quality & style

As you revise, keep names descriptive, use comments to explain decisions rather than restating code, and avoid repeating the same calculation in several places.

## Criterion 4: Documentation

- Your README documents commands, outputs, dependencies and limitations. It also records an independent height example and a debugging comparison; these are useful accounts of your checks, although the checking process itself was not independently observed.

## Criterion 5: Version-control practice

- Required paths are present, supplied inputs are unchanged, and no generated results are tracked. The reviewed Git history includes descriptive, task-focused commits.

## Criterion 8: Basic error-handling & input validation

- Before final submission, no specific numerical output defect was identified in the supplied checks. Focus revision on making the complete route from measurements to checked outputs easy to reproduce.
- Before final submission, **Make validation evidence diagnostic.** The invalid runs halted without producing an output, with messages identifying an out-of-range distance in the fixed route and a non-finite distance in the generalised route. This supports those tested cases, not every validation branch. For each route, rerun one ordinary case and one deliberately invalid case, checking that stderr identifies the value you changed and that no new result is written. Use a clean test output location, or distinguish an older result from a newly generated one.

## Criterion 9: Problem-solving approach & method implementation

- The Pound Hill richness table had the expected rows, plot identifiers and richness values. Your code connects the metadata’s treatment of blanks to species counts, quadrat richness and then plot-level means. The comments explain why plots receive equal weight and distinguish richness from abundance without claiming causation.
- When I opened the figure, I found a clear figure title, readable axes and a useful caption explaining the points and replication. This adds evidence beyond simply generating a PDF.
- Before final submission, **Complete the figure-to-data check.** The automated check only confirmed that the PDF existed; I found the figure readable, so compare at least one plotted point with its CSV row. Compare a point in `results/pound_hill_plot_richness.pdf` with its CSV row, then trace that plot mean back to its quadrat richness values. This checks both the aggregation and the biological meaning of the axis.

## Criterion 10: Learning progression demonstration

Use this feedback as a revision checklist. Make the changes in small, descriptive commits, then add a short README note explaining what you changed and how you checked it. This will make your development from this formative checkpoint visible in the final portfolio.

## Priorities before final submission

- Follow your documented commands from the directory containing `code/`, `data/` and the root `README.md`. Test the fixed script, generalised script and shell wrapper separately.
- Repeat your independent height calculation for a selected input row, keeping units explicit, and compare it with both tree-height outputs.
- Record the small diagnostic checks and their observed outcomes in the README, then commit any revisions with a descriptive message while keeping generated results untracked.
