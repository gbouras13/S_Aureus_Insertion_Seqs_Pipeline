rule collate_per_sample:
    """Collate."""
    input:
        os.path.join(TMP,"{sample}_isfinder_parsed.csv"),
        os.path.join(MMSEQS2,"{sample}_cluster.tsv" )
    output:
        os.path.join(RESULTS,"{sample}_final_per_is.csv"),
        os.path.join(RESULTS,"{sample}_summary.csv")
    conda:
        os.path.join('..', 'envs','collate.yaml')
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/collate.py'

rule aggr_collate:
    """Aggregate."""
    input:
        expand(os.path.join(RESULTS,"{sample}_final_per_is.csv"), sample = SAMPLES_not_empty),
        expand(os.path.join(RESULTS,"{sample}_summary.csv"), sample = SAMPLES_not_empty)
    output:
        os.path.join(LOGS, "aggr_collate.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
