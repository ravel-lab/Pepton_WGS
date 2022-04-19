#!/bin/bash

#use the current working directory and current modules
#$ -cwd -V

#$ -b y -l mem_free=64G -P jravel-lab -q threaded.q -pe thread 8 -N gtdbtk -j y -o /local/scratch/mfrance/logs/ -e /local/scratch/mfrance/logs/

module unload python
module load gtdb-tk/1.5.1

cd /local/scratch/mfrance/EZAK/classify

gtdbtk classify_wf --cpus 8 -x .fna --genome_dir /local/scratch/mfrance/EZAK/classify/ --out_dir /local/scratch/mfrance/EZAK/
