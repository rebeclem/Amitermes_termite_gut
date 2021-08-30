# Part 7 - Count number of mapped reads

All of these commands need to be called while on an interactive node (not in home). To get an interactive node do:
```
salloc -p short -t 200 -N 1
squeue # you will see a node### in the output
ssh node### 
```
cd to /Analysis/ folder



Load `samtools`.
```
module load samtools
```


#### Counting the number of __HUMAN__ mapped reads.

1st, convert the `sam` file to a `bam` file. This will make it binary, so it takes up less space and is quicker to count. If you have large files, it may be good to run this using a script like samtobam.sh(samtobam.sh).

The & at the end means that you can type in the next command before it finishes.

```
for d in *; do 
    samtools view -b $d/human/outalign.sam > $d/human/outalign.bam && echo "Converted $d/outalign.sam" &
done & 
```

2nd, pull all the mapped read names from the `bam` file. The -F command, only displays the primary-mapped reads.
```
for d in *; do 
    samtools view -F 4 $d/human/outalign.bam | cut -f1 > $d/human/tmp.txt && echo $d &
done &
```

3rd, count unique reads.
This is counting the number of *unique* reads that mapped to the human database and writes the number of unique reads and sample name to a file.
```
echo -e "Samp\tReads" >> reads_hg.txt
for d in *; do 
   readnum=$(cat $d/human/tmp.txt | python ../scripts/count_uniq.py)
   echo -e "${d}\t${readnum}" >> reads_hg.txt
   echo $d $readnum
done 
```

---
---
---



#### Counting the number of __BACTERIA__ mapped reads.
If you have other files in with your sample directory, try this from Nate instead:
```
cat ../samps.txt | while read d; do samtools view -b $d/bac/outalign.sam > $d/bac/outalign.bam ; echo "Converted $d/outalign.sam"; done
```

1st, convert the `sam` file to a `bam` file.
```
for d in *; do 
    samtools view -b $d/bac/outalign.sam > $d/bac/outalign.bam && echo "Converted $d/outalign.sam" &
done & 
```

2nd, pull all the mapped read names from the `bam` file.
```
for d in *; do 
    samtools view -F 4 $d/bac/outalign.bam | cut -f1 > $d/bac/tmp.txt && echo $d &
done &
```

3rd, count unique reads.
This is counting the number of *unique* reads that mapped to the bacteria databases and writes the number of unique reads and sample name to a file.
```
echo -e "Samp\tReads" >> reads_bac.txt
for d in *; do 
   readnum=$(cat $d/bac/tmp.txt | python ../scripts/count_uniq.py)
   echo -e "${d}\t${readnum}" >> reads_bac.txt
   echo $d $readnum
done 
```

After you have converted the `.sam` files to `.bam` files, you can delete the `.sam` files to save space. However, be careful if you have done it on an interactive node, because it may not have completed.
<br />

---
---

## Setting up the files to be ready for visualization in R.
### Now you have two files:
1. `reads_hg.txt`
2. `reads_bac.txt`

Which both have the format of:

| Samp | Reads |
| --- | --- |
| Konzo01 | 1302387 |

Take both of these files and combine them in excel and add the grouping so the file looks like such:

| Samp	| bac.reads	| hum.reads	| unmap.reads	| Group |
| ---- | --- | --- | --- | --- |
| Konzo01 |	1302387	| 1031	| 8695258	| Kinshasa Control |

To get the unmapped reads column, use the number of cleaned reads (from read_counts.csv) divided by 2 (cleaned vs raw reads is talking about total, not paired reads), and subtract the number that mapped to bacteria and human.

Next step: [Visualize in R](R_analysis.md)
