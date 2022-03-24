
from itertools import chain
import pandas as pd

def samplesFromDirectoryEmpty(dir):
    """Parse samples from a directory"""
    outDict = {}
    # https://stackoverflow.com/questions/11860476/how-to-unnest-a-nested-list
    samples_all= glob_wildcards(os.path.join(dir,'{sample}_isfinder.ffn'))
    samples_all = chain(*samples_all)
    # check if empty
    samples = []
    for sample in samples_all:
        file = str(sample) + '_isfinder.ffn'
        if os.stat(os.path.join(dir, file)).st_size == 0:
            samples.append(sample)

    #samples2 = chain(*samples)
    for sample in samples:
        outDict[sample] = {}
        fasta = os.path.join(dir,f'{sample}_isfinder.ffn')
        if os.path.isfile(fasta):
            outDict[sample]['fasta'] = fasta
        else:
            sys.stderr.write("\n"
                             "    FATAL: Error globbing files."
                             f"    {fasta} \n"
                             "    does not exist. Ensure consistent formatting and file extensions."
                             "\n")
            sys.exit(1)
    return outDict

def parseSamplesEmpty(readFileDir):
    """Parse samples from a directory"""
    if os.path.isdir(readFileDir):
        sampleDict = samplesFromDirectoryEmpty(readFileDir)
    else:
        sys.stderr.write("\n"
                         f"    FATAL: {readFileDir} is neither a file nor directory.\n"
                         "\n")
        sys.exit(1)
    if len(sampleDict.keys()) == 0:
        sys.stderr.write("\n"
                         "    There are no empty samples.\n"
                         "\n")
        sampleDict = {}
    return sampleDict

def writeEmptyCsv(list, dir):
    """write to csv the empty samples"""
    #create new df 
    empty_df = pd.DataFrame({'Sample':list})
    empty_df.to_csv(os.path.join(dir, 'samples_with_no_transposons.csv'), sep=',', index=False)
