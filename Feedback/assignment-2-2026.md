# Assignment 2 formative feedback

This feedback is organised by the relevant computing bootcamp criteria. Use it to decide what is already working, what you need to investigate, and what to revise before the cumulative submission.

The full criteria are in the [Computing Bootcamp assessment rubric](https://github.com/MulQuaBio/MQB/blob/main/content/rubrics/Computing_Bootcamp_Rubric.md).

## 1. Repository organisation and workflow discipline

- Your root README, `.gitignore`, cleaning script, test script and supplied data files are in the expected locations. The supplied CSV and metadata are unchanged, giving you a reproducible starting point.

## 2. Code completeness and functional correctness

- The cleaning workflow ran successfully. Separately, output checks found that all three output tables satisfied the requirements on both test runs. The outputs are correct for the checked input; before final submission, test a few important edge cases and make sure you can explain the method.

## 3. Code quality and style

- Your `main()` function gives the program a clear overall structure by connecting loading, processing, summarising and writing. Keep these stages distinct as you revise; use descriptive names and add short comments where the reason for a validation check or data-cleaning step is not obvious.

## 4. Documentation

- Your root README is in place. Make it useful to someone opening the repository for the first time: explain what the cleaner does, how to run the script and tests from the repository root, and which three files it creates. Test the instructions in a newly cloned copy of your repository (a separate folder created with `git clone`): enter that folder and run each README command exactly as written. If something fails, correct the command or add the missing step.

## 5. Version-control practice

- Since the previous formative feedback was added, the saved history contains 3 non-merge commits. `Complete Silwood tree cleaning assignment and tests` identifies the relevant work, but combines implementation and testing in one large checkpoint. `Hello Samraat` does not describe a repository change.
- Before each commit, run `git diff --staged` to see exactly what will be recorded. Keep one coherent, working change per commit and write a concise message that names what changed—for example, the validation rule added, the failing test fixed or the README instruction clarified.

## 8. Basic error handling and input validation

- Your supplied raw CSV and metadata remain unchanged. The required files, including the separate test file, are present.
- Your separate tests ran successfully. Your test file includes checks for record validation, accepted/rejected partitioning and oak summaries, including duplicate IDs, invalid records not reserving IDs, numeric boundaries, non-finite numbers and missing fields. These provide useful targeted checks beyond simply running the full script.
- Review test coverage against the brief, then rerun the separate tests and full cleaning workflow after any changes.

## 9. Problem-solving approach and method implementation

- Your code shows a clear connected workflow: `main()` calls `load_records()`, passes the rows to `process_records()`, which uses `validate_record()` and returns `(clean_records, issues)`. The cleaned collection feeds `summarise_oaks()`, and three `write_csv()` calls write the results. The route from input to outputs is clear.
- Before final submission, make this check visible in your repository. In `code/test_silwood_trees.py`, add or refine a small assertion-based test with one valid and one invalid record. Check that `process_records()` places them in the cleaned and issues collections respectively. Then pass the returned cleaned collection to `summarise_oaks()` and check that the invalid record does not contribute. Briefly explain this flow in your root README.
