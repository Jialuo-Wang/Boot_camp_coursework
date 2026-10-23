# Calculate tree height from distance in metres and angle in degrees.
TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  return(height)
}

# Require exactly one input CSV path.
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 1) {
  stop("Usage: Rscript code/get_TreeHeight.R <input.csv>")
}

input_path <- args[1]

# Check that the input is a readable file.
if (!file.exists(input_path) || dir.exists(input_path)) {
  stop("Input file does not exist or is not a regular file: ", input_path)
}

if (file.access(input_path, mode = 4) != 0) {
  stop("Input file is not readable: ", input_path)
}

if (!grepl("\\.csv$", input_path, ignore.case = TRUE)) {
  stop("Input file must have a .csv extension.")
}

trees <- read.csv(input_path, stringsAsFactors = FALSE)

# Inspect the column names, first rows, and column types.
print(names(trees))
print(head(trees))
str(trees)
# Check the required columns and their order.
required_columns <- c("Species", "Distance.m", "Angle.degrees")

if (!identical(names(trees), required_columns)) {
  stop("Expected columns: Species, Distance.m, Angle.degrees")
}

# Check that distances are numeric, finite, and within range.
if (!is.numeric(trees$Distance.m)) {
  stop("Distance.m must be numeric.")
}

if (any(!is.finite(trees$Distance.m))) {
  stop("Distance.m must contain only finite values.")
}

if (any(trees$Distance.m <= 0 | trees$Distance.m > 100)) {
  stop("Distance.m must be greater than 0 and at most 100.")
}

# Check that angles are numeric, finite, and within range.
if (!is.numeric(trees$Angle.degrees)) {
  stop("Angle.degrees must be numeric.")
}

if (any(!is.finite(trees$Angle.degrees))) {
  stop("Angle.degrees must contain only finite values.")
}

if (any(trees$Angle.degrees <= 0 | trees$Angle.degrees >= 90)) {
  stop("Angle.degrees must be greater than 0 and less than 90.")
}

print("Input checks passed.")
# Calculate heights while preserving the original row order.

trees$height_m <- TreeHeight(
  degrees = trees$Angle.degrees,
  distance = trees$Distance.m
)

# Build the output filename from the input basename.
input_name <- basename(input_path)
input_stem <- sub("\\.csv$", "", input_name, ignore.case = TRUE)
output_path <- file.path(
  "results",
  paste0(input_stem, "_treeheights.csv")
)

# Create the output directory if needed.
dir.create("results", showWarnings = FALSE)

# Prevent overwriting the input, including through symbolic links.
input_absolute <- normalizePath(input_path, mustWork = TRUE)

output_absolute <- if (file.exists(output_path)) {
  normalizePath(output_path, mustWork = TRUE)
} else {
  file.path(
    normalizePath("results", mustWork = TRUE),
    basename(output_path)
  )
}

if (identical(input_absolute, output_absolute)) {
  stop("Output path must not overwrite the input file.")
}

# Write the results, replacing any previous output.
write.csv(trees, output_path, row.names = FALSE)

print(head(trees))
cat("Saved", nrow(trees), "records to", output_path, "\n")