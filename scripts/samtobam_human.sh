#!/bin/bash
#SBATCH -N 1
#SBATCH -t 10:00:00
#SBATCH -p defq,short,gpu
#SBATCH -o samtobam.%A_%a.out
#SBATCH -e samtobam.%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

module load samtools

cat ../samps.txt | while read d; do samtools view -b $d/human2/outalign.sam > $d/human2/outalign.bam ; echo "Converted $d/outalign.sam"; done

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
