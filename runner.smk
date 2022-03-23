"""
The snakefile that runs the pipeline.
Manual launch example:

snakemake -c 1 -s runner.smk --use-conda --config Assemblies=Fastas/  --conda-create-envs-only --conda-frontend conda
compute node
snakemake -c 16 -s wgs_runner.smk --use-conda --config Assemblies=Fastas/ Output=out/ --force
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

# Parse the samples and read files
include: "rules/samples.smk"
sampleAssemblies = parseSamples(ASSEMBLIES)
SAMPLES = sampleAssemblies.keys()

# Import rules and functions
include: "rules/targets.smk"
include: "rules/prokka.smk"
include: "rules/cluster.smk"
include: "rules/collate.smk"
include: "rules/summarise.smk"

rule all:
    input:
        TargetFiles
