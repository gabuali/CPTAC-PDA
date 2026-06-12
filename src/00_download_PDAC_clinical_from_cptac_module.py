
import cptac
import time

# Initialize the dataset for pancreatic ductal adenocarcinoma (PDAC)
pdac = cptac.Pdac()

# Retrieve the clinical data for the PDAC dataset and save it to a CSV file
clinical = pdac.get_clinical(source="mssm")
clinical.to_csv(path_or_buf="../Data/Metadata/PDAC_clinical.csv")
