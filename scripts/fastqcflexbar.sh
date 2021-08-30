#!/bin/bash
#SBATCH -J fastqc
#SBATCH -o fastqcflexbar.out
#SBATCH -e fastqcflexbar.err
#SBATCH -p short
#SBATCH -n 16
#SBATCH -t 2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

module load fastQC 

for f in *; do
fastqc -o $f -f fastq $f/flexcleaned_1.fastq $f/flexcleaned_2.fastq
done
