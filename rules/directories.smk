"""
Database and output locations for Hecatomb
Ensures consistent variable names and file locations for the pipeline.
"""


DBDIR = 'Databases'
KRAKENTOOLSDIR = 'Kraken_Tools'

### OUTPUT DIRECTORY
if config['Output'] is None:
    OUTPUT = 's_aureus_output'
else:
    OUTPUT = config['Output']




### OUTPUT DIRs
RESULTS = os.path.join(OUTPUT, 'RESULTS')
WORKDIR = os.path.join(OUTPUT, 'PROCESSING')
TMP = os.path.join(WORKDIR, 'TMP')
LOGS = os.path.join(OUTPUT, 'LOGS')



