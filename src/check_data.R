rna <- read.csv('Data/MOFA_input/transcriptome_top5k_hvgs_scaled_tumor.csv', row.names=1)
prot <- read.csv('Data/MOFA_input/proteome_top5k_hvgs_scaled_tumor.csv', row.names=1)

cat('=== SAMPLE OVERLAP ===\n')
cat('RNA samples:', ncol(rna), '\n')
cat('Proteome samples:', ncol(prot), '\n')
cat('Common samples:', length(intersect(colnames(rna), colnames(prot))), '\n')
cat('All equal before reordering?', all(colnames(rna) == colnames(prot)), '\n\n')

# Reorder proteome to match RNA
prot <- prot[, colnames(rna)]
cat('All equal after reordering?', all(colnames(rna) == colnames(prot)), '\n\n')

# Check for NA and extreme values
rna_mat <- as.matrix(rna)
prot_mat <- as.matrix(prot)

cat('=== DATA QUALITY ===\n')
cat('RNA:\n')
cat('  NAs:', sum(is.na(rna_mat)), '/', length(rna_mat), '(', round(sum(is.na(rna_mat))/length(rna_mat)*100, 2), '%)\n')
cat('  Infs:', sum(is.infinite(rna_mat)), '\n')
cat('  Range:', paste(range(rna_mat, na.rm=TRUE), collapse=' to '), '\n')
cat('  Mean:', mean(rna_mat, na.rm=TRUE), '\n')
cat('  SD:', sd(rna_mat, na.rm=TRUE), '\n')

cat('\nProteome:\n')
cat('  NAs:', sum(is.na(prot_mat)), '/', length(prot_mat), '(', round(sum(is.na(prot_mat))/length(prot_mat)*100, 2), '%)\n')
cat('  Infs:', sum(is.infinite(prot_mat)), '\n')
cat('  Range:', paste(range(prot_mat, na.rm=TRUE), collapse=' to '), '\n')
cat('  Mean:', mean(prot_mat, na.rm=TRUE), '\n')
cat('  SD:', sd(prot_mat, na.rm=TRUE), '\n')

# Check variance per feature
cat('\n=== VARIANCE CHECK ===\n')
rna_var <- apply(rna_mat, 1, var, na.rm=TRUE)
prot_var <- apply(prot_mat, 1, var, na.rm=TRUE)

cat('RNA features with 0 variance:', sum(rna_var == 0, na.rm=TRUE), '\n')
cat('RNA features with NA variance:', sum(is.na(rna_var)), '\n')
cat('Proteome features with 0 variance:', sum(prot_var == 0, na.rm=TRUE), '\n')
cat('Proteome features with NA variance:', sum(is.na(prot_var)), '\n')

# Check for problematic features (all NA or near-zero variance)
prot_na_prop <- rowSums(is.na(prot_mat)) / ncol(prot_mat)
cat('\nProteome features with >80% missing:', sum(prot_na_prop > 0.8), '\n')
if(sum(prot_na_prop > 0.8) > 0) {
  cat('Examples:\n')
  print(head(names(prot_na_prop)[prot_na_prop > 0.8], 10))
}
