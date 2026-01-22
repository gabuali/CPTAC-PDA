# merge multiple RNA-seq count files into a single TSV using pandas
# take only Raw counts from 'unstranded' column

from pathlib import Path
import pandas as pd
import logging

# Setup logging for better visibility during execution
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

# Directory containing the files
DATA_DIR = Path("RNAseq/gdc_download_20260111_183645.628203")
# Output file
OUTPUT_FILE = "PDAC_transcriptomics_RAW_counts.tsv"

def main():
    if not DATA_DIR.exists():
        logging.error(f"Data directory not found: {DATA_DIR}")
        return

    # Find all the files using rglob (recursive glob)
    files = list(DATA_DIR.rglob("*.rna_seq.augmented_star_gen"))

    if not files:
        logging.warning(f"No files found matching the pattern in: {DATA_DIR}")
        return

    logging.info(f"Found {len(files)} files. Starting merge...")

    # Initialize a list to hold dataframes
    dfs = []

    for file_path in files:
        try:
            # Read the file, skipping the first line (comment)
            # GDC files often have 4 rows of stats at the top; 'comment' handles the header
            df = pd.read_csv(file_path, sep='\t', comment='#', low_memory=False)

            # Filter out GDC stats rows (N_unmapped, etc.) which don't have a gene_name
            df = df.dropna(subset=['gene_name'])

            # Set the index. Using all three ensures we keep metadata for the final output.
            df = df.set_index(['gene_id', 'gene_name', 'gene_type'])

            # Keep only the 'unstranded' column and rename it to the filename
            df = df[['unstranded']].rename(columns={'unstranded': file_path.name})

            dfs.append(df)
        except Exception as e:
            logging.error(f"Failed to process {file_path.name}: {e}")

    if not dfs:
        logging.error("No dataframes were successfully loaded.")
        return

    # Merge all dataframes. The default join is 'outer', which is a union of the indexes.
    merged_df = pd.concat(dfs, axis=1, sort=False)

    # Write the result to a tsv file
    merged_df.to_csv(OUTPUT_FILE, sep='\t')
    logging.info(f"Successfully merged {len(dfs)} files into {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
