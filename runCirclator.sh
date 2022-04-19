#!/bin/bash
#use the current working directory and current modules
#$ -cwd -V

#$ -b y -l mem_free=8G -P jravel-lab -q all.q -N circulator -j y -o /local/scratch/mfrance/logs/ -e /local/scratch/mfrance/logs/

#setting the number of jobs to be executed
#$ -t 1-1
cd /local/scratch/mfrance/PACBIO/02_circulise
source /local/groupshare/ravel/mfrance/software/circlator/env/bin/activate

infile=`sed -n -e "$SGE_TASK_ID p" to_circ.lst`

circlator fixstart --verbose --min_id 98 --genes_fa  dnaA.fasta ${infile}_circ.fasta ${infile}
