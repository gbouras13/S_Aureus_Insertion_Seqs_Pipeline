rule summarise:
    """Collate."""
    input:
        finals = expand(os.path.join(RESULTS,"{sample}_final_per_is.csv"), sample = SAMPLES),
        cluster = os.path.join(MMSEQS2, "total_all_samples_cluster.tsv")
    output:
        os.path.join(RESULTS,"total_all_samples_final_per_is.csv"),
        os.path.join(RESULTS,"total_all_samples_summary.csv")
    conda:
        os.path.join('..', 'envs','summarise.yaml')
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/summarise_all_samples.py'

rule aggr_summarise:
    """Aggregate."""
    input:
        os.path.join(RESULTS,"total_all_samples_final_per_is.csv"),
        os.path.join(RESULTS,"total_all_samples_summary.csv")
    output:
        os.path.join(LOGS, "aggr_summarise.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
