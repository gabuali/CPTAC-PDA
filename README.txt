Multiomics Factor Analysis (MOFA) of CPTAC-PDAC RNAseq, proteome, and mutation data from study https://doi.org/10.1016/j.cell.2021.08.023

=======
Scripts
=======

Merged metadata file metadata_merged_clinical_mol-phenotype_from_paper.csv compiled from several sources with exploratory.ipynb

Raw RNAseq count table subset to contain same sample set and gene set as LinkedOmics using exploratory.ipynb.

TPM normalization using tpm_normalization.ipynb

PurIST basal/classical calls on TPM normalized RNA counts made using PurIST R package with script runPURIST.r

RNAseq and proteomics data were prepped for MOFA analysis using script mofa_prep_input.ipynb

MOFA model trained on RNA and protein data using mofa_train_model.rmd

MOFA model 2 trained on RNA, protein, and mutation data using mofa_train_model_v2.rmd



=====
Data sources
=====

Transcriptome and proteome tables are from LinkedOmics db.

Data downloaded from 
https://www.linkedomics.org/data_download/CPTAC-PDAC/
https://linkedomics.org/data_download/CPTAC-PDAC/mRNA_RSEM_UQ_log2_Tumor.cct
https://linkedomics.org/data_download/CPTAC-PDAC/mRNA_RSEM_UQ_log2_Normal.cct
https://linkedomics.org/data_download/CPTAC-PDAC/mRNA_RSEM_UQ_log2_Duct.cct
https://linkedomics.org/data_download/CPTAC-PDAC/proteomics_gene_level_MD_abundance_tumor.cct
https://linkedomics.org/data_download/CPTAC-PDAC/proteomics_gene_level_MD_abundance_normal.cct
https://linkedomics.org/data_download/CPTAC-PDAC/clinical_table_140.tsv

mRNA pipeline for RNA data in LinkedOmics db
https://docs.gdc.cancer.gov/Data/Bioinformatics_Pipelines/Expression_mRNA_Pipeline/

mRNA pipeline for RNA data in flagship paper
https://github.com/ding-lab/cptac_rna_expression

Use the gene information (gencode.gene.info.v22.tsv; md5: 0a3f1d9b0a679e2a426de36d8d74fbf9) on the GDC Reference Files page to get extra information about each gene.
https://gdc.cancer.gov/about-data/data-harmonization-and-generation/gdc-reference-files
https://api.gdc.cancer.gov/data/b011ee3e-14d8-4a97-aed4-e0b10f6bbe82
https://www.gencodegenes.org/human/release_22.html
https://genome-euro.ucsc.edu/cgi-bin/hgTrackUi?db=hg38&g=wgEncodeGencodeV22

---

File PDAC_clinical.csv is from python cptac module for the PDAC study.

---

The raw RNAseq files were downloaded from https://portal.gdc.cancer.gov/  PROJECT CPTAC-3
The metadata tables were also downloaded from https://portal.gdc.cancer.gov/
Raw RNAseq were merged into PDAC_transcriptomics_RAW_counts.tsv and column headers renamed to contain Case IDs in file PDAC_transcriptomics_RAW_counts_renamed.tsv.

---

in cptac module 
TRANSCRIPTOME
	Source	File Metadata / Transformations	Unit in DataFrame
	Broad	rsem_transcripts_tpm.txt.gz							log2(TPM+1)
	BCM		gene_rsem_removed_circRNA_..._UQ_log2(x+1).txt.gz	log2(FPKM-UQ+1)
	WashU	rsem_counts.txt.gz									log2(Counts+1)
	
---

PROTEOME - Proteomic metadata was downloaded from 
https://pdc.cancer.gov/pdc/study/PDC000270
https://pdc.cancer.gov/pdc/browse
	log2 transformed
	Normalized protein abundance (reference intensity normalized; median-normalized intensity). This is standard for CPTAC mass-spec proteomics - they use log2 ratios computed by the CDAP (CPTAC Data Analysis Pipeline).
	

------
ROIVolume - more accurate than tumor size.

File Metadata_Report_CPTAC_PDA_2025_10_20-1.csv from https://www.cancerimagingarchive.net/analysis-result/cptac-pda-tumor-annotations/

	Use 'ROIVolume' column instead of tumor size for linking with RNAseq.  Use rows that have 'Segmentation' value in column 'Annotation type'
	Also, use rows with PANCREAS-1 in StructureSetLabel column. While PANCREAS - 1 is almost always the largest, primary tumor mass, the existence of a - 2 (or - 3) entry indicates that the radiologist identified a separate area that required its own measurement.  If there is a PANCREAS-2 it means that the tumor is multifocal.  You can sum the ROIVolume in that case to get Total Tumor Burden.
	