#!/bin/bash
#SBATCH -p medium
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -t 1-00:00:00
#SBATCH -o reports/maxikraken2/logs/%J.log --mail-type=ALL
#SBATCH --array=1-30
#SBATCH --mem=160G

module load kraken2

maxikraken2=$HOME/bin/rebecca_clement_GWU/microbiome/db/maxikraken2_1903_140GB/

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p samps.txt)
sample=$(sed -n "$SLURM_ARRAY_TASK_ID"p names.txt)

echo $name
echo $sample

kraken2 \
	--paired "${name}"/flexcleaned_1.fastq.gz "${name}"/flexcleaned_2.fastq.gz \
	--db "${maxikraken2}" \
	--threads 10 \
	--report reports/maxikraken2/"${sample}".report \
	--confidence 0.5
