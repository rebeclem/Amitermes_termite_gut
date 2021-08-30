#!/bin/bash
#SBATCH -N 1
#SBATCH -t 20:00:00
#SBATCH -p defq,short,gpu
#SBATCH -o samtobamhuman3.%A_%a.out
#SBATCH -e samtobamhuman3.%A_%a.err
#SBATCH --array=1-25
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p ../samps.txt)

module load samtools

#cat ../samps.txt | while read d; do samtools view -b $d/bac_prinseq/outalign.sam > $d/bac_prinseq/outalign.bam ; echo "Converted $d/outalign.sam"; done
samtools view -b $name/human3/outalign.sam > $name/human3/outalign.bam 
 echo "Converted $name/outalign.sam"

#for d in *; do 
#    samtools view -b $d/bac_prinseq/outalign.sam > $d/bac_prinseq/outalign.bam && echo "Converted $d/outalign.sam" &
#done &

#for d in *; do 
 #  samtools view -F 4 $d/bac_prinseq/outalign.bam | cut -f1 > $d/bac_prinseq/tmp.txt && echo $d &
#done &

#echo -e "Samp\tReads" >> reads_bac_prinseq.txt
#for d in *; do 
#  readnum=$(cat $d/bac_prinseq/tmp.txt | python ../scripts/count_uniq.py)
#   echo -e "${d}\t${readnum}" >> reads_bac.txt
#   echo $d $readnum
# done 
