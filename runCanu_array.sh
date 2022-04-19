#!/bin/bash
#use the current working directory and current modules
#$ -cwd -V

#$ -b y -l mem_free=256G -P jravel-lab -q threaded.q -pe thread 16 -N canu_isolates -j y -o /local/scratch/mfrance/logs/ -e /local/scratch/mfrance/logs/

#setting the number of jobs to be executed
#$ -t 1-19

cd /local/scratch/mfrance/PACBIO/01_canu

infile=`sed -n -e "$SGE_TASK_ID p" pbio.lst`

strain="$(cut -d ',' -f 1 <<< "$infile" )"
genomeSize="$(cut -d ',' -f 2 <<< "$infile" )"

datadir=/local/scratch/mfrance/PACBIO/00_raw

/usr/local/packages/canu/bin/canu maxInputCoverage=1500 -p $strain -d ${strain} genomeSize=$genomeSize -pacbio-raw $datadir/${strain}.fastq.gz gridOptionsJobName=canu_$strain gridOptions="-S /bin/sh -P jravel-lab -b y -V -q threaded.q"  gridEngineThreadsOption="-pe thread THREADS" gridEngineMemoryOption="-l mem_free=MEMORY" oeaThreads=2 oeaMemory=128 redMemory=128 batMemory=256 minReadLength=1000 gnuplot=/usr/local/packages/gnuplot/bin/gnuplot maxThreads=16 maxMemory=256 
