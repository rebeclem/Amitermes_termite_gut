#!/bin/bash
#SBATCH -N 1
#SBATCH -t 2-00:00:00
#SBATCH -p defq,large-gpu,small-gpu
#SBATCH -o PS_bac.%A_%a.out
#SBATCH -e PS_bac.%A_%a.err
#SBATCH --array=1-33
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p ../samps.txt)

#--- Start the timer
t1=$(date +"%s")

echo $name
mkdir -p $name/bac

module load pathoscope
module load bowtie2

pathoscope MAP -numThreads $(nproc)\
 -outDir $name/bac \
 -indexDir ../refs \
 -targetIndexPrefixes ref_prok_rep_genomes.00_ti,ref_prok_rep_genomes.01_ti,ref_prok_rep_genomes.02_ti,ref_prok_rep_genomes.03_ti,ref_prok_rep_genomes.06_ti,ref_prok_rep_genomes.07_ti \
 -filterIndexPrefixes nasExi,phix174,zooNev,amiFal \
 -1 $(ls $name/flexcleaned_1.fastq) \
 -2 $(ls $name/flexcleaned_2.fastq)

 echo "Completed running PathoMAP on bac for $name"


pathoscope ID \
 -outDir $name/bac \
 -thetaPrior 10000000 \
 -alignFile $name/bac/outalign.sam

 echo "Completed running PathoID on bac for $name"

 # this removes all unnecessary files that are taking up a lot of room.
rm $name/bac/pathomap-*

#---Complete job
t2=$(date +"%s")
diff=$(($t2-$t1))
echo "[---$SN---] ($(date)) $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "[---$SN---] ($(date)) $SN COMPLETE."
