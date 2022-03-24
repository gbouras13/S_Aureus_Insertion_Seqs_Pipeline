#### if you want to only look at the unmapped READS
#### I have decided to look at them all for now

rule prokka:
    """Run prokka."""
    input:
        os.path.join(ASSEMBLIES, "{sample}.fasta")
    output:
        os.path.join(TMP,"{sample}","{sample}.gff" ),
        os.path.join(TMP,"{sample}","{sample}.ffn" )
    conda:
        os.path.join('..', 'envs','prokka.yaml')
    params:
        os.path.join(TMP, "{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    shell:
        """
        prokka --outdir {params[0]}  --prefix {wildcards.sample} {input[0]} --force
        """

rule clean_gff:
    """Extract only the rows of gff to read as dataframe."""
    input:
        os.path.join(TMP,"{sample}","{sample}.gff")
    output:
        os.path.join(TMP,"{sample}_no_fasta.gff")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        awk '/##sequence-region/{{flag=1;next}}/##FASTA/{{flag=0}}flag' {input[0]} > {output[0]}
        """

rule get_isfinder_only:
    """Extract only rows with IS Finder."""
    input:
        os.path.join(TMP,"{sample}_no_fasta.gff")
    output:
        os.path.join(TMP,"{sample}_clean.gff")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    script:
        '../scripts/is_finder_gff.py'

rule parse_gff:
    """ Parse the cleaned ISfinder gff """
    input:
        os.path.join(TMP,"{sample}_clean.gff")
    output:
        os.path.join(TMP,"{sample}_isfinder_parsed.csv")
    conda:
        os.path.join('..', 'envs','prokka.yaml')
    script:
        '../scripts/gff_parse.py'

rule extract_fastas:
    """ Extract the ISFinder Fastas """
    input:
        os.path.join(TMP,"{sample}_isfinder_parsed.csv"),
        os.path.join(TMP,"{sample}","{sample}.ffn" )
    output:
        os.path.join(TMP,"{sample}_isfinder.ffn" )
    conda:
        os.path.join('..', 'envs','prokka.yaml')
    script:
        '../scripts/extract_fastas.py'


#### aggregation rule

rule aggr_prokka:
    """Aggregate."""
    input:
        expand(os.path.join(TMP,"{sample}_isfinder.ffn" ), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_prokka.txt")
    threads:
        1
    resources:
        mem_mb=BigJobMem
    shell:
        """
        touch {output[0]}
        """
