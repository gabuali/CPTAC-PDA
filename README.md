# CPTAC-PDAC Multi-Omics Factor Analysis (MOFA)

Multi-omics integration analysis of CPTAC Pancreatic Ductal Adenocarcinoma (PDAC) data combining RNAseq, proteomics, and mutation data.

**Reference Study:** [Cao et al., Cell 2021](https://doi.org/10.1016/j.cell.2021.08.023)

The purpose of this analysis is to find a molecular signature that is an independent predictor of overall survival; using an approach that has not been used in the referenced study from which the data were sourced.

---

## 📁 Project Structure

```
├── Data/
│   ├── Annotations/          # Gene annotations (GENCODE v22, GDC reference)
│   ├── APGI-PDA/             # APGI validation data
│   ├── LinkedOmics_CPTAC/   # LinkedOmics CPTAC-PDAC data files
│   ├── Metadata/             # Clinical and sample metadata
│   ├── MOFA_input/           # Prepared matrices for MOFA
│   ├── MSigDB_genesets/      # Hallmark gene set collection
│   ├── PDAC_transcriptomics_RAW_counts_renamed.tsv  # Raw RNA counts (GTEx + TCGA + CPTAC)
│   └── Tong-PDA/             # Tong et al. validation data
├── Results/
│   ├── MOFA_models/          # Trained MOFA HDF5 models
│   ├── PurIST_Classification_Results.csv  # Basal/Classical subtype calls
│   ├── 11_check_leading_edge_coverage.html
│   ├── 12_find_discriminatory_signature.html
│   ├── 13_apgi_prep_data.html
│   ├── 14_validate_signature_apgi.html
│   ├── 15_prepare_tong_validation_data.html
│   ├── 16_tong_validation_survival_analysis.html
│   ├── factor2_under_the_hood.html
│   ├── gsea_mofa_factor2.html
│   ├── mofa_downstream_exploratory.html
│   └── survival_analysis.html
└── src/                      # Analysis scripts
```

---

## 🔬 Analysis Pipeline

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_exploratory.ipynb` | Merge metadata, subset samples/genes to match LinkedOmics |
| 2 | `02_tpm_normalization.ipynb` | TPM normalize raw RNA counts |
| 3 | `03_runPURIST.r` | PurIST basal/classical subtype classification |
| 4 | `04_mofa_prep_input.ipynb` | Prepare RNAseq & proteomics matrices for MOFA |
| 5 | `05_mofa_train_model.Rmd` | Train MOFA model on RNA + protein |
| 6 | `06_mofa_train_model_v2.rmd` | Train MOFA model on RNA + protein + mutations |
| 7 | `07_mofa_downstream_exploratory.rmd` | Explore MOFA factors and clinical correlations |
| 8 | `08_survival_analysis.rmd` | Survival analysis using MOFA factors |
| 9 | `09_factor2_under_the_hood.rmd` | Deep dive into Factor 2 genes/proteins |
| 10 | `10_gsea_mofa_factor2.rmd` | Gene Set Enrichment Analysis using MOFA Factor 2 |
| 11 | `11_check_leading_edge_coverage.Rmd` | Check leading edge protein detection in validation cohorts |
| 12 | `12_find_discriminatory_signature.rmd` | Lasso-Cox signature discovery (3 input sets, prevalence check) |
| 13 | `13_apgi_prep_data.rmd` | Process APGI protein matrix and map gene symbols |
| 14 | `14_validate_signature_apgi.rmd` | External validation of two signatures in APGI cohort |
| 15 | `15_prepare_tong_validation_data.Rmd` | Prepare Tong proteomics data for two-signature validation |
| 16 | `16_tong_validation_survival_analysis.Rmd` | External validation of two signatures in Tong cohort |

> **Note:** Mutation data explained <0.5% of variance, so MOFAmodel_1 (RNA + protein only) was used for downstream analysis.

### 📄 View Analysis Reports

| Report | Description |
|--------|-------------|
| [MOFA Downstream Exploratory](https://gabuali.github.io/CPTAC-PDA/Results/mofa_downstream_exploratory.html) | Factor exploration and clinical correlations |
| [Survival Analysis](https://gabuali.github.io/CPTAC-PDA/Results/survival_analysis.html) | Cox regression and Kaplan-Meier curves |
| [Factor 2 Deep Dive](https://gabuali.github.io/CPTAC-PDA/Results/factor2_under_the_hood.html) | Top genes/proteins driving Factor 2 |
| [GSEA Factor 2](https://gabuali.github.io/CPTAC-PDA/Results/gsea_mofa_factor2.html) | Hallmark pathway enrichment analysis |
| [Survival Signature Discovery](https://gabuali.github.io/CPTAC-PDA/Results/12_find_discriminatory_signature.html) | Three-way Lasso-Cox comparison (Full, Tong≥80%, Both≥80%) |
| [Leading Edge Coverage Check](https://gabuali.github.io/CPTAC-PDA/Results/11_check_leading_edge_coverage.html) | Leading edge protein detection across cohorts |
| [APGI Data Preparation](https://gabuali.github.io/CPTAC-PDA/Results/13_apgi_prep_data.html) | Process APGI protein matrix and map gene symbols |
| [APGI Signature Validation](https://gabuali.github.io/CPTAC-PDA/Results/14_validate_signature_apgi.html) | External validation of both signatures in APGI cohort |
| [Tong Data Preparation](https://gabuali.github.io/CPTAC-PDA/Results/15_prepare_tong_validation_data.html) | Prepare Tong proteomics for two-signature validation |
| [Tong Signature Validation](https://gabuali.github.io/CPTAC-PDA/Results/16_tong_validation_survival_analysis.html) | External validation of both signatures in Tong cohort |

---

## 📊 Data Sources

### LinkedOmics Database
Transcriptome and proteome tables from [LinkedOmics CPTAC-PDAC](https://www.linkedomics.org/data_download/CPTAC-PDAC/)

| Data Type | File |
|-----------|------|
| Tumor RNA | `mRNA_RSEM_UQ_log2_Tumor.cct` |
| Normal RNA | `mRNA_RSEM_UQ_log2_Normal.cct` |
| Duct RNA | `mRNA_RSEM_UQ_log2_Duct.cct` |
| Tumor Proteome | `proteomics_gene_level_MD_abundance_tumor.cct` |
| Normal Proteome | `proteomics_gene_level_MD_abundance_normal.cct` |
| Clinical | `clinical_table_140.tsv` |

### Raw RNAseq
Downloaded from [GDC Portal - CPTAC-3](https://portal.gdc.cancer.gov/)
- Merged: `PDAC_transcriptomics_RAW_counts.tsv`
- Renamed: `Data/PDAC_transcriptomics_RAW_counts_renamed.tsv`

### Proteomics
Downloaded from [PDC Study PDC000270](https://pdc.cancer.gov/pdc/study/PDC000270)
- Log2 transformed, reference intensity normalized, median-normalized abundance
- Standard CPTAC CDAP pipeline processing

### Clinical Metadata
- `PDAC_clinical.csv` — from Python `cptac` module
- `Metadata_Report_CPTAC_PDA_2025_10_20-1.csv` — from [Cancer Imaging Archive](https://www.cancerimagingarchive.net/analysis-result/cptac-pda-tumor-annotations/)

---

## ✅ Signature Validation in Tong-PDA Study

Two Lasso-Cox signatures (Tong ≥80% and Both Cohorts ≥80%) are validated using independent proteomics data from the Tong et al. (2022) PDAC cohort.

**Tong Study Publication:** [Proteomic landscape of pancreatic ductal adenocarcinoma](https://doi.org/10.1186/s13045-022-01384-z)
*Journal of Hematology & Oncology, 2022*

**Data Sources:**

**Proteomics & Clinical Data:** Supplemental Table S3A (protein groups) and Table S1B (clinical metadata)

| File | Description |
|------|-------------|
| `Data/Tong-PDA/13045_2022_1384_MOESM25_ESM.xlsx` | Table S3A: 7,055 protein groups by DIA-MS (226 tumors, 220 NATs) |
| `Data/Tong-PDA/13045_2022_1384_MOESM23_ESM.xlsx` | Table S1B: Clinical metadata with overall survival |
| `Data/Tong-PDA/tong_validation_data_prepared.csv` | Z-score normalized signature proteins with risk scores |
| `Data/Tong-PDA/tong_signature_proteins_scaled.csv` | Scaled expression matrix of signature proteins |

**Raw RNA-seq:** Available from the [Genome Sequence Archive for Human (GSA-Human)](https://ngdc.cncb.ac.cn/gsa-human/browse/HRA002195) under accession HRA002195

**Discovery Results (CPTAC):**
| Signature | Proteins | C-index | HR (95% CI) | p-value | AUC (1yr) | AUC (2yr) |
|-----------|----------|---------|-------------|---------|-----------|-----------|
| Full Leading Edge | 21 | 0.730 | 4.44 (3.14-6.27) | 2.9e-17 | 0.794 | 0.817 |
| Tong ≥80% | 20 | 0.707 | 4.98 (3.27-7.57) | 6.6e-14 | 0.767 | 0.796 |
| Both Cohorts ≥80% | 17 | 0.700 | 4.92 (3.22-7.50) | 1.5e-13 | 0.756 | 0.789 |

**Validation Results (Tong Cohort):**
| Signature | Proteins Used | C-index | HR (95% CI) | p-value |
|-----------|--------------|---------|-------------|---------|
| Tong ≥80% | 20/20 | 0.563 | 2.08 (1.17-3.70) | 0.012 |
| Both ≥80% | 17/17 | 0.565 | 1.94 (1.06-3.56) | 0.032 |

---

## ✅ Signature Validation in APGI-PDA Study Protein Data

Two Lasso-Cox signatures (Tong ≥80% and Both Cohorts ≥80%) are validated using independent proteomics data from the Australian Pancreatic Cancer Genome Initiative (APGI).

**APGI Study Publication:**  
[Mapping the Proteomic Landscape of Pancreatic Ductal Adenocarcinoma](https://aacrjournals.org/cancerrescommun/article/5/10/1879/766828/Mapping-the-Proteomic-Landscape-of-Pancreatic)

**Data Source:**  
PRIDE Archive Project PXD059074  
https://ftp.pride.ebi.ac.uk/pride/data/archive/2025/09/PXD059074/

| File | Description |
|------|-------------|
| `Data/APGI-PDA/APGI_protein_matrix_and_metadata.csv` | Protein abundance matrix with sample metadata |
| `Data/APGI-PDA/APGI_protein_and_gene_names.csv` | Protein/gene name mapping, populated from PRIDE archive |
| `Data/APGI-PDA/APGI_protein_matrix.csv` | Protein-only abundance matrix (step 13 output) |
| `Data/APGI-PDA/APGI_clinical_metadata.csv` | Clinical metadata subset (step 13 output) |

**Validation Results (APGI):**
| Signature | Proteins Used | C-index | HR (95% CI) | p-value |
|-----------|--------------|---------|-------------|---------|
| Tong ≥80% | 20/20 | 0.510 | 1.36 (0.51-3.64) | 0.546 |
| Both ≥80% | 17/17 | 0.585 | 1.48 (0.97-2.25) | 0.070 |

---

## 📝 Technical Notes

### RNA Pipeline References
- **LinkedOmics:** [GDC mRNA Pipeline](https://docs.gdc.cancer.gov/Data/Bioinformatics_Pipelines/Expression_mRNA_Pipeline/)
- **Flagship Paper:** [ding-lab/cptac_rna_expression](https://github.com/ding-lab/cptac_rna_expression)

### Gene Annotations
GENCODE v22 gene info from [GDC Reference Files](https://gdc.cancer.gov/about-data/data-harmonization-and-generation/gdc-reference-files)
- File: `gencode.gene.info.v22.tsv`
- MD5: `0a3f1d9b0a679e2a426de36d8d74fbf9`

### CPTAC Module Data Units

| Source | File Pattern | Unit |
|--------|--------------|------|
| Broad | `rsem_transcripts_tpm.txt.gz` | log2(TPM+1) |
| BCM | `gene_rsem_removed_circRNA_..._UQ_log2(x+1).txt.gz` | log2(FPKM-UQ+1) |
| WashU | `rsem_counts.txt.gz` | log2(Counts+1) |

### Tumor Volume (ROIVolume)
More accurate than `tumor_size_cm` for linking with RNAseq data.

**Usage notes:**
- Use rows with `Annotation type = "Segmentation"`
- Use rows with `StructureSetLabel = "PANCREAS-1"` (primary tumor mass)
- If `PANCREAS-2` exists → multifocal tumor; sum ROIVolume for Total Tumor Burden

---

## 🛠️ Requirements

### Python
Python 3.10+ recommended. Install dependencies:
```bash
pip install -r requirements.txt
```

**Key Python packages:**
| Package | Version | Purpose |
|---------|---------|---------|
| pandas | 2.3.3 | Data manipulation |
| numpy | 2.4.1 | Numerical operations |
| matplotlib | 3.10.8 | Plotting |
| seaborn | 0.13.2 | Statistical visualization |
| scikit-learn | 1.8.0 | Machine learning utilities |
| mofapy2 | 0.7.3 | MOFA Python backend |
| mofax | 0.3.7 | MOFA utilities |
| h5py | 3.15.1 | HDF5 file handling |
| jupyter | 1.1.1 | Notebook environment |

### R
R 4.3+ recommended.

**CRAN packages:**
```r
install.packages(c("tidyverse", "here", "survival", "survminer", 
                   "GGally", "psych", "ggplot2", "devtools"))
```

**Bioconductor packages:**
```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("MOFA2", "fgsea"))
```

**GitHub packages:**
```r
# PurIST classifier for PDAC subtyping
devtools::install_github("wwsean08/runPURIST")
```

| Package | Source | Purpose |
|---------|--------|---------|
| MOFA2 | Bioconductor | Multi-omics factor analysis |
| tidyverse | CRAN | Data wrangling & visualization |
| survival | CRAN | Survival analysis |
| survminer | CRAN | Survival visualization |
| glmnet | CRAN | Lasso-Cox regression |
| timeROC | CRAN | Time-dependent ROC analysis |
| impute | Bioconductor | KNN imputation for missing values |
| fgsea | Bioconductor | Gene set enrichment analysis |
| GGally | CRAN | Pairs plots & correlations |
| psych | CRAN | Correlation utilities |
| here | CRAN | Project-relative paths |
| runPURIST | GitHub | Basal/classical PDAC classification |

---

## 📄 License

This project uses publicly available CPTAC, APGI, and Tong data. Please cite the original studies where appropriate, when using this analysis.
