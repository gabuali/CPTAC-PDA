
import cptac
import time

pdac = cptac.Pdac()

files_to_download = [
    ('broad', 'transcriptomics'),
    ('umich', 'phosphoproteomics'),
    ('umich', 'proteomics'),
    ('washu', 'cibersort'),
    ('washu', 'CNV'),
    ('washu', 'somatic_mutation'),
    ('washu', 'transcriptomics'),
    ('washu', 'xcell'),
    ('bcm', 'circular_RNA'),
    ('bcm', 'CNV'),
    ('bcm', 'miRNA'),
    ('bcm', 'phosphoproteomics'),
    ('bcm', 'transcriptomics'),
]

for source, datatype in files_to_download:
    print(f"Downloading {datatype} from {source}...")
    try:
        if datatype == 'transcriptomics':
            pdac.get_transcriptomics(source=source)
        elif datatype == 'phosphoproteomics':
            pdac.get_phosphoproteomics(source=source)
        elif datatype == 'proteomics':
            pdac.get_proteomics(source=source)
        elif datatype == 'cibersort':
            pdac.get_cibersort(source=source)
        elif datatype == 'CNV':
            pdac.get_CNV(source=source)
        elif datatype == 'somatic_mutation':
            pdac.get_somatic_mutation(source=source)
        elif datatype == 'xcell':
            pdac.get_xcell(source=source)
        elif datatype == 'circular_RNA':
            pdac.get_circular_RNA(source=source)
        elif datatype == 'miRNA':
            pdac.get_miRNA(source=source)
        print(f"Successfully downloaded {datatype} from {source}.")
    except Exception as e:
        print(f"Could not download {datatype} from {source}.")
        print(e)
    
    print("Waiting for 60 seconds before next download...")
    time.sleep(60)
