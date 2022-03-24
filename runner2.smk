"""
The 2nd runner file - need to break when we have empty fastas

snakemake -c 1 -s runner2.smk --use-conda --config Assemblies=Fastas/  --conda-create-envs-only --conda-frontend conda
snakemake -c 16 -s runner2.smk --use-conda --config Assemblies=Fastas/ Output=out/ 
"""


### DEFAULT CONFIG FILE
configfile: os.path.join(workflow.basedir,  'config', 'config.yaml')

BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]

### DIRECTORIES

include: "rules/directories.smk"

# get if needed
ASSEMBLIES = config['Assemblies']
OUTPUT = config['Output']

# Import rules and functions
include: "rules/targets2.smk"

# if empty remove samples

include: "rules/empty_files.smk"
include: "rules/non_empty_files.smk"

sampleAssemblies_not_empty = parseSamplesNonEmpty(TMP)
SAMPLES_not_empty = sampleAssemblies_not_empty.keys()
sampleAssemblies_empty = parseSamplesEmpty(TMP)
SAMPLES_empty = sampleAssemblies_empty.keys()


# needs to be created before the empty samples are written
if not os.path.exists(RESULTS):
  os.makedirs(RESULTS)

writeEmptyCsv(SAMPLES_empty, RESULTS)

include: "rules/cluster.smk"
include: "rules/collate.smk"
include: "rules/summarise.smk"

rule all:
    input:
        TargetFiles
