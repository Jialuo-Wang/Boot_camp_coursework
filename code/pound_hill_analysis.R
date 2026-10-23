# Analyse plant species richness at Pound Hill.
# Run this script from the repository root.

# Read all rows as data because the first four rows contain sample labels.
pound_raw <- read.csv(
  "data/pound_hill_data.csv",
  header = FALSE,
  stringsAsFactors = FALSE,
  colClasses = "character"
)

# Read the metadata using its semicolon separator.
pound_meta <- read.csv(
  "data/pound_hill_meta_data.csv",
  sep = ";",
  stringsAsFactors = FALSE,
  strip.white = TRUE
)

# Inspect dimensions, column types and a small section of the raw data.
print(dim(pound_raw))
str(pound_raw[, seq_len(min(6, ncol(pound_raw)))])
print(pound_raw[
  seq_len(min(8, nrow(pound_raw))),
  seq_len(min(6, ncol(pound_raw)))
])

# Inspect the complete metadata.
print(dim(pound_meta))
str(pound_meta)
print(pound_meta)
# Display the metadata explanation for blank species counts.
blank_note <- pound_meta$Description[
  pound_meta$FieldName == "BlankSpeciesCount"
]
cat("\nMeaning of blank species counts:\n")
cat(blank_note, sep = "\n")

# Check the labels in the first four rows.
sample_fields <- c("Cultivation", "Block", "Plot", "Quadrat")
stopifnot(identical(pound_raw[1:4, 1], sample_fields))

# Transpose sample information: one row per quadrat.
samples <- as.data.frame(
  t(as.matrix(pound_raw[1:4, -1])),
  stringsAsFactors = FALSE
)
names(samples) <- sample_fields
rownames(samples) <- NULL

# Check that each quadrat has a unique combination of sample labels.
stopifnot(!anyDuplicated(samples))

cat("\nFirst six quadrats:\n")
print(head(samples))

cat("\nNumber of quadrats:\n")
print(nrow(samples))

cat("\nNumber of plots:\n")
print(nrow(unique(samples[c("Cultivation", "Block", "Plot")])))

cat("\nNumber of sampled quadrats per plot:\n")
print(aggregate(
  Quadrat ~ Cultivation + Block + Plot,
  data = samples,
  FUN = length
))
# Extract species names and check that they are non-empty and unique.
species <- trimws(pound_raw[-(1:4), 1])
stopifnot(
  !anyNA(species),
  all(nzchar(species)),
  !anyDuplicated(species)
)

# Extract species counts, excluding sample labels and species names.
count_text <- as.matrix(pound_raw[-(1:4), -1])

# The supplied metadata defines blank species counts as observed absences.
# Convert only blank cells to zero; unexpected missing values remain errors.
count_text[] <- trimws(count_text)
blank_cells <- !is.na(count_text) & count_text == ""
count_text[blank_cells] <- "0"

# Convert counts to numbers and reject invalid values.
counts <- matrix(
  as.numeric(count_text),
  nrow = nrow(count_text),
  ncol = ncol(count_text)
)
stopifnot(
  all(is.finite(counts)),
  all(counts >= 0)
)

# Build a long table: one row per species in each quadrat.
# R reads matrix values column by column, matching this row order.
n_species <- length(species)
pound_long <- samples[
  rep(seq_len(nrow(samples)), each = n_species),
]
rownames(pound_long) <- NULL
pound_long$Species <- rep(species, times = nrow(samples))
pound_long$Count <- as.vector(counts)

# Check the reshaped table.
stopifnot(
  nrow(pound_long) == n_species * nrow(samples),
  !anyDuplicated(pound_long[c(sample_fields, "Species")])
)

cat("\nNumber of distinct species:\n")
print(length(unique(pound_long$Species)))

cat("\nDimensions of the long table:\n")
print(dim(pound_long))

cat("\nFirst six rows of the long table:\n")
print(head(pound_long))

cat("\nCount range:\n")
print(range(pound_long$Count))
# Calculate richness as the number of species with a positive count.
quadrat_richness <- aggregate(
  Count ~ Cultivation + Block + Plot + Quadrat,
  data = pound_long,
  FUN = function(x) sum(x > 0)
)
names(quadrat_richness)[5] <- "Richness"

# Check that all quadrats are retained and richness is within bounds.
stopifnot(
  nrow(quadrat_richness) == nrow(samples),
  !anyDuplicated(quadrat_richness[sample_fields]),
  all(quadrat_richness$Richness >= 0),
  all(quadrat_richness$Richness <= n_species)
)

cat("\nFirst six quadrat richness values:\n")
print(head(quadrat_richness))

# Calculate the mean quadrat richness within each plot.
plot_richness <- aggregate(
  Richness ~ Cultivation + Block + Plot,
  data = quadrat_richness,
  FUN = mean
)
names(plot_richness)[4] <- "MeanRichness"

# Sort plots by their numeric labels for readable output.
plot_richness <- plot_richness[
  order(as.integer(plot_richness$Plot)),
]
rownames(plot_richness) <- NULL

# Confirm that each of the 12 plots appears exactly once.
stopifnot(
  nrow(plot_richness) == 12L,
  !anyDuplicated(plot_richness$Plot),
  all(is.finite(plot_richness$MeanRichness))
)

# Save the plot-level summary without row numbers.
dir.create("results", showWarnings = FALSE)
write.csv(
  plot_richness,
  "results/pound_hill_plot_richness.csv",
  row.names = FALSE
)

cat("\nPlot-level mean richness:\n")
print(plot_richness)
cat("\nSaved results/pound_hill_plot_richness.csv\n")
# Set the treatment order for plotting.
plot_richness$Cultivation <- factor(
  plot_richness$Cultivation,
  levels = c("march", "may", "october")
)

# Save a figure showing all individual plot values.
pdf(
  "results/pound_hill_plot_richness.pdf",
  width = 7,
  height = 5
)

par(mar = c(6, 5, 3, 1))

# Use fixed horizontal offsets to keep nearby plot values visible.
block_offsets <- c(a = -0.12, b = -0.04, c = 0.04, d = 0.12)
x_positions <- as.integer(plot_richness$Cultivation) +
  unname(block_offsets[plot_richness$Block])

treatment_colours <- c("#0072B2", "#009E73", "#D55E00")

plot(
  x_positions,
  plot_richness$MeanRichness,
  xlim = c(0.6, 3.4),
  ylim = c(0, max(plot_richness$MeanRichness) + 1),
  xaxt = "n",
  pch = 19,
  col = treatment_colours[as.integer(plot_richness$Cultivation)],
  cex = 1.3,
  xlab = "Cultivation treatment",
  ylab = "Mean species richness per quadrat",
  main = "Plant species richness at Pound Hill"
)

axis(
  side = 1,
  at = 1:3,
  labels = c("March", "May", "October")
)

mtext(
  "Each point represents one plot; four plots per treatment.",
  side = 1,
  line = 4.5,
  cex = 0.8
)

dev.off()

cat("\nSaved results/pound_hill_plot_richness.pdf\n")
# Calculate the total number of plant individuals in each quadrat.
quadrat_abundance <- aggregate(
  Count ~ Cultivation + Block + Plot + Quadrat,
  data = pound_long,
  FUN = sum
)
names(quadrat_abundance)[5] <- "Abundance"

stopifnot(
  nrow(quadrat_abundance) == nrow(samples),
  all(is.finite(quadrat_abundance$Abundance)),
  all(quadrat_abundance$Abundance >= 0)
)

# Calculate mean quadrat abundance within each plot.
plot_abundance <- aggregate(
  Abundance ~ Cultivation + Block + Plot,
  data = quadrat_abundance,
  FUN = mean
)
names(plot_abundance)[4] <- "MeanAbundance"

plot_abundance <- plot_abundance[
  order(as.integer(plot_abundance$Plot)),
]
rownames(plot_abundance) <- NULL

stopifnot(
  nrow(plot_abundance) == 12L,
  !anyDuplicated(plot_abundance$Plot)
)

write.csv(
  plot_abundance,
  "results/pound_hill_plot_abundance.csv",
  row.names = FALSE
)

cat("\nPlot-level mean abundance:\n")
print(plot_abundance)

# Compare treatment means, giving each plot equal weight.
comparison <- merge(
  plot_richness,
  plot_abundance,
  by = c("Cultivation", "Block", "Plot")
)

cat("\nTreatment means across plots:\n")
print(aggregate(
  cbind(MeanRichness, MeanAbundance) ~ Cultivation,
  data = comparison,
  FUN = mean
))
# May cultivation has the highest mean plot-level richness (9.65 species
# per quadrat), with variation among plots and overlap between treatments.
# October has the highest mean abundance (205.20 individuals per quadrat)
# but the lowest mean richness (7.61), showing that more individuals do
# not necessarily mean more species.
# The figure alone cannot establish causation; assessing a cultivation
# effect requires information about treatment randomisation, blocking,
# baseline plot differences and other management conditions.