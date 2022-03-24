# bash run_pipeline.sh -c {cores} -f {fastas} -o {output}

while getopts f:o:c: flag
do
    case "${flag}" in
        f) query=${OPTARG};;
        o) output=${OPTARG};;
        c) cores=${cores};;
    esac
done

snakemake -c ${cores} -s runner.smk --use-conda --config Assemblies=${query} Output=${output}
snakemake -c ${cores} -s runner2.smk --use-conda --config Assemblies=${query} Output=${output}

