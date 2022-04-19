#!/bin/bash

#use the current working directory and current modules
#$ -cwd -V

#$ -b y -l mem_free=16G -P jravel-lab -q threaded.q -pe thread 4 -N pgates_prokka -j y -o /local/scratch/mfrance/logs/ -e /local/scratch/mfrance/logs/

#setting the number of jobs to be executed
#$ -t 1-2

cd /local/scratch/mfrance/PACBIO/03_annotation

infile=`sed -n -e "$SGE_TASK_ID p" redo.lst`

genome="$(cut -d ',' -f 1 <<< "$infile" )"
genus="$(cut -d ',' -f 2 <<< "$infile" )"
species="$(cut -d ',' -f 3 <<< "$infile" )"

prokka --cpus 4 --compliant --outdir ./prokka_output/${genome}/  --genus $genus --species $species --strain $genome --prefix $genome ${genome}.fasta
