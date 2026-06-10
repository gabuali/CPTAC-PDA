# The PurIST (Purity Independent Subtyping of Tumors) classifier is specifically designed to handle the low neoplastic cellularity of PDAC. It simplifies the 5-subtype schema (Puleo) or 4-subtype schema (Bailey) into a clinically actionable Binary Classification: Basal-like (aggressive, resistant) vs. Classical (better prognosis, FOLFIRINOX-responsive).

# How PurIST Works: The "Top-Scoring Pairs" (TSP) - Unlike standard clustering, PurIST doesn't care about absolute expression levels, which are easily diluted by stroma. Instead, it uses Top-Scoring Pairs (TSP). It looks at the relative rank of 16 specific genes (8 pairs) within a single sample.

# Logic: If Gene A > Gene B, it contributes a "point" toward one subtype.
# Result: This makes it immune to "batch effects" and "stromal dilution" because the internal ratio of tumor genes remains consistent even if the total amount of tumor RNA is small.

# The 16-Gene List (8 Pairs)
# The classifier evaluates the following genes. In each pair, one is typically "Basal-enriched" and the other is "Classical-enriched."
# Basal-Enriched Genes,  Classical-Enriched Genes
# GPR87,REG4
# KRT6A,ANXA10
# BCAR3,GATA6
# PTGES,CLDN18
# ITGA3,LGALS4
# C16orf74,DDC
# S100A2,SLC40A1
# KRT5,CLRN3
# Note: GATA6 is often considered the "master regulator" of the Classical subtype; its loss is a hallmark of the Basal-like state.

library(runPURIST)

# Prepare your data
# Ensure your matrix has HGNC symbols as row names 
# and log2-TPM (or FPKM) values as data.
# matrix_name: log2_tpm_matrix
log2_tpm_matrix = read.csv("Data/PDAC_tx_TPM_log2_normalized_linkedomics_tumor.csv", row.names = 1)

# Load the built-in classifier data included in the package
# This usually loads an object named 'classifs' or 'purist_model'
data("fitteds_public_2019-02-12") 

# Extract the primary classifier (it is usually the first element in a list)
my_classifier <- classifs[[1]]

# Run the classifier
# The main function is usually apply_classifier or purist_predict
# depending on the internal version, but apply_classifier is the standard.
results <- apply_classifier(data = log2_tpm_matrix, classifier = my_classifier)

# Inspect the results
head(results)

sum(c("GPR87", "KRT6A", "BCAR3", "PTGES", "ITGA3", "C16orf74", "S100A2", "KRT5") %in% rownames(log2_tpm_matrix))

# head log2_tpm_matrix for genes GPR87 KRT6A BCAR3 PTGES ITGA3 C16orf74 S100A2 KRT5
log2_tpm_matrix[c("GPR87", "KRT6A", "BCAR3", "PTGES", "ITGA3", "C16orf74", "S100A2", "KRT5"),]

# Save results to CSV
write.csv(results, file = "Results/PurIST_Classification_Results.csv")
