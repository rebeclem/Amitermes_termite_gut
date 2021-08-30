#!/bin/bash
#SBATCH -N 1
#SBATCH -t 05:00:00
#SBATCH -p defq,short,small-gpu
#SBATCH -o PS_termite.%A_%a.out
#SBATCH -e PS_termite.%A_%a.err
#SBATCH --array=1-33
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p ../samps.txt)

#--- Start the timer
t1=$(date +"%s")

echo $name
mkdir -p $name/termite

module load pathoscope
module load bowtie2
pathoscope MAP -numThreads $(nproc)\
 -outDir $name/termite \
 -indexDir ../refs \
 -targetIndexPrefixes amiFal,nasExi,zooNev \
 -filterIndexPrefixes phix174,hg38full\
 -1 $(ls $name/flexcleaned_1.fastq) \
 -2 $(ls $name/flexcleaned_2.fastq)

 echo "Completed running PathoMAP on human for $name"


pathoscope ID \
 -outDir $name/termite \
 -thetaPrior 10000000 \
 -alignFile $name/termite/outalign.sam

 echo "Completed running PathoID on termite for $name"


# this removes all unnecessary files that are taking up a lot of room.
rm $name/termite/pathomap-*

#---Complete job
t2=$(date +"%s")
diff=$(($t2-$t1))
echo "[---$SN---] ($(date)) $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "[---$SN---] ($(date)) $SN COMPLETE."
