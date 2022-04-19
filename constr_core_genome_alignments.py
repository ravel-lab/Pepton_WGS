#!/usr/bin/python3
import sys
import pandas as pd
from Bio.SeqIO.FastaIO import SimpleFastaParser
import re
from Bio.Align.Applications import MuscleCommandline

#Reading the major fasta file into a pandas dataframe with the header as one column and the sequence as the other
with open(sys.argv[2]) as fasta_file:
    headers = []
    seqs = []
    for rec, sequence in SimpleFastaParser(fasta_file):
        headers.append(rec)
        seqs.append(str(sequence))

fasta_df = pd.DataFrame(dict(header=headers, seq=seqs)).set_index(['header'])
fasta_df['Genome'] = fasta_df.index.str.split("|").str[0]
fasta_df['Length'] = fasta_df['seq'].str.len()

core = 0
paralog = 0

genome_key = pd.read_csv(sys.argv[3],sep=",",index_col=0)
#gard_key = genome_key[genome_key['Classification']!='Gardnerella']
#outgroupStrains = list(genome_key[genome_key['Classification']!='Gardnerella']['Moniker'])

numAll = len(genome_key.index)
paralogLimit = int((numAll)*0)
coreLimit = int((numAll)*0.98)

#creating a file to store partition information
with open(sys.argv[1]) as orthologs: 

    for cnt, ortholog in enumerate(orthologs):
        
        (orthoID,geneList) = ortholog.split(":")
        geneList = geneList.rstrip().split(" ")[1:]
        print(orthoID)

        #removing the outgroup strains for the initial alignments to decide within species clustering
        #for outgroup in outgroupStrains:
        #    geneList=[x for x in geneList if outgroup not in x]

        genomeList = list(set([x.split("|")[0] for x in geneList]))
        numProteins = len(geneList)
        numGenomes = len(genomeList)

        if numProteins > numGenomes+paralogLimit:
            paralog+=1

        elif numGenomes >= coreLimit:
            core+=1

            orthologSeqsDF = fasta_df.loc[geneList].sort_values(['Genome','Length'],axis=0,ascending=False).reset_index()
            orthologSeqsDF = orthologSeqsDF.groupby("Genome").first().reset_index()

            inFasta= '%s.fasta' %(orthoID)
            alignFasta = '%s.aln.fasta' %(orthoID)

            orthologFastaOut = open(inFasta,'w')

            loop_count = 1

            for index,row in orthologSeqsDF.iterrows():

                if loop_count < numGenomes:
                    orthologFastaOut.write('>'+row['Genome']+'\n'+row['seq']+'\n')
                    loop_count+=1
                elif loop_count == numGenomes:
                    orthologFastaOut.write('>'+row['Genome']+'\n'+row['seq'])

            orthologFastaOut.close()

            #cline = MuscleCommandline(input=inFasta,out=alignFasta)
            #cline()

print("paralog\t" + str(paralog))
print("core\t" + str(core))