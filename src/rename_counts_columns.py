import pandas as pd
from pathlib import Path

def rename_counts_columns():
    """
    Renames column headers in PDAC_transcriptomics_RAW_counts.tsv using 
    mappings from gdc_sample_sheet.2026-01-11.tsv.
    """
    # Define paths based on your directory structure
    base_path = Path("/Users/galebabu-ali/Documents/CPTAC-PDA/Data/RNAseq")
    sample_sheet_path = base_path / "gdc_sample_sheet.2026-01-11.tsv"
    counts_file_path = Path("PDAC_transcriptomics_RAW_counts.tsv")
    output_file_path = Path("PDAC_transcriptomics_RAW_counts_renamed.tsv")

    # 1. Load the sample sheet
    if not sample_sheet_path.exists():
        print(f"Error: Sample sheet not found at {sample_sheet_path}")
        return
    
    sample_df = pd.read_csv(sample_sheet_path, sep='\t')

    # 2. Create mapping: Truncated File Name -> Case ID
    # The headers in the counts file are truncated by removing 'e_counts.tsv'
    suffix_to_remove = "e_counts.tsv"
    name_mapping = {}
    
    for _, row in sample_df.iterrows():
        full_filename = str(row['File Name'])
        # Truncate the filename to match the counts file headers
        if full_filename.endswith(suffix_to_remove):
            truncated_key = full_filename[:-len(suffix_to_remove)]
        else:
            truncated_key = full_filename
        
        # Extract Case ID (taking the first ID if multiple are listed, e.g., "ID, ID")
        case_id = str(row['Case ID']).split(',')[0].strip()
        name_mapping[truncated_key] = case_id

    # 3. Load the RAW counts file
    if not counts_file_path.exists():
        print(f"Error: Counts file not found at {counts_file_path}")
        return

    counts_df = pd.read_csv(counts_file_path, sep='\t')

    # 4. Rename columns (skipping the first three)
    old_columns = counts_df.columns.tolist()
    new_columns = old_columns[:3] # Preserve first 3 columns (e.g., Gene ID, Symbol, etc.)

    for col in old_columns[3:]:
        # Replace with Case ID if found in mapping, otherwise keep original
        new_columns.append(name_mapping.get(col, col))

    counts_df.columns = new_columns

    # 5. Save the updated TSV
    counts_df.to_csv(output_file_path, sep='\t', index=False)
    print(f"Successfully processed columns. Renamed file saved to: {output_file_path}")

if __name__ == "__main__":
    rename_counts_columns()