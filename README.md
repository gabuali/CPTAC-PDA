# CPTAC-PDAC Multi-Omics Factor Analysis (MOFA)

Multi-omics integration analysis of CPTAC Pancreatic Ductal Adenocarcinoma (PDAC) data combining RNAseq, proteomics, and mutation data.

**Reference Study:** [Clark et al., Cell 2021](https://doi.org/10.1016/j.cell.2021.08.023)

The purpose of this analysis is to find a molecular signature that is an independent predictor of overall survival; using an approach that has not been used in the referenced study from which the data were sourced.

---

## 📁 Project Structure

```
├── Data/
│   ├── Annotations/          # Gene annotations (GENCODE v22)
│   ├── LinkedOmics_data/     # Transcriptome, proteome, mutation data
│   ├── Metadata/             # Clinical and sample metadata
│   ├── MOFA_input/           # Prepared matrices for MOFA
│   ├── RNA_count_tables/     # Raw and normalized RNA counts
│   └── RNAseq_raw/           # GDC raw downloads
├── Results/
│   └── MOFA_models/          # Trained MOFA HDF5 models
└── src/                      # Analysis scripts
```

---

## 🔬 Analysis Pipeline

| Step | Script | Description |
|------|--------|-------------|
| 1 | `exploratory.ipynb` | Merge metadata, subset samples/genes to match LinkedOmics |
| 2 | `tpm_normalization.ipynb` | TPM normalize raw RNA counts |
| 3 | `runPURIST.r` | PurIST basal/classical subtype classification |
| 4 | `mofa_prep_input.ipynb` | Prepare RNAseq & proteomics matrices for MOFA |
| 5 | `mofa_train_model.rmd` | Train MOFA model on RNA + protein |
| 6 | `mofa_train_model_v2.rmd` | Train MOFA model on RNA + protein + mutations |
| 7 | `mofa_downstream_exploratory.rmd` | Explore MOFA factors and clinical correlations |
| 8 | `survival_analysis.rmd` | Survival analysis using MOFA factors |
| 9 | `factor2_under_the_hood.rmd` | Deep dive into Factor 2 genes/proteins |
| 10 | `gsea_mofa_factor2.rmd` | Gene Set Enrichment Analysis using MOFA Factor 2 |

> **Note:** Mutation data explained <0.5% of variance, so MOFAmodel_1 (RNA + protein only) was used for downstream analysis.

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
- Merged into `PDAC_transcriptomics_RAW_counts.tsv`
- Renamed columns with Case IDs: `PDAC_transcriptomics_RAW_counts_renamed.tsv`

### Proteomics
Downloaded from [PDC Study PDC000270](https://pdc.cancer.gov/pdc/study/PDC000270)
- Log2 transformed, reference intensity normalized, median-normalized abundance
- Standard CPTAC CDAP pipeline processing

### Clinical Metadata
- `PDAC_clinical.csv` — from Python `cptac` module
- `Metadata_Report_CPTAC_PDA_2025_10_20-1.csv` — from [Cancer Imaging Archive](https://www.cancerimagingarchive.net/analysis-result/cptac-pda-tumor-annotations/)

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
| fgsea | Bioconductor | Gene set enrichment analysis |
| GGally | CRAN | Pairs plots & correlations |
| psych | CRAN | Correlation utilities |
| here | CRAN | Project-relative paths |
| runPURIST | GitHub | Basal/classical PDAC classification |

---

## 📄 License

This project uses publicly available CPTAC data. Please cite the original study when using this analysis.
