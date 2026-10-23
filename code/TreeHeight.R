# Calculate tree height from distance in metres and angle in degrees.
TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  return(height)
}

# Read the supplied data from the repository root.
trees <- read.csv("data/trees.csv", stringsAsFactors = FALSE)

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

# Create the output directory if needed.
dir.create("results", showWarnings = FALSE)

# Write the table, replacing any previous output.
write.csv(trees, "results/TreeHts.csv", row.names = FALSE)

# Display the first rows and the number of records written.
print(head(trees))
cat("Saved", nrow(trees), "records to results/TreeHts.csv\n")