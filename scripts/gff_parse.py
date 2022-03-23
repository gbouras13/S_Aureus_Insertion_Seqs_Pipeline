#!/usr/bin/env python3

import pandas as pd

def extract_is_seq(sample, output):
  # read in cleaned df of ISfinder element
  colnames=['contig', 'evidence', 'type', 'start', 'end', 'score', 'strand', 'n', 'description'] 
  abundance_df = pd.read_csv(sample, delimiter= '\t', index_col=False, header=None, names=colnames)

  # function to get the locus tag (between ID= and the first semi colon)

  def find_between( s, first, last ):
      try:
          start = s.index( first ) + len( first )
          end = s.index( last, start )
          return s[start:end]
      except ValueError:
          return ""

  # get is_name and locus_tage
  abundance_df['locus_tag'] = abundance_df['description'].apply(lambda x: find_between(x,"ID=", ";"  ) )
  abundance_df['IS_name'] = abundance_df['description'].apply(lambda x: find_between(x,"ISfinder:", ";locus_tag"  ) )
  # get the product
  # https://stackoverflow.com/questions/37333299/splitting-a-pandas-dataframe-column-by-delimiter
  abundance_df[['description','product']] = abundance_df['description'].str.split('product=',expand=True)
  

  # write to csv
  abundance_df.to_csv(output, sep=",", index=False, header=False)
  
 
extract_is_seq(snakemake.input[0], snakemake.output[0])




