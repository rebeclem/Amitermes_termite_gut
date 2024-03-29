# Part 6 - Pathoscope

We will map to Pathoscope 3X. First, targetting termite. We want to know how much termite "contamination" is in our samples - how many reads belong to termite. Second, we will map to the NCBI bacterial databases. Finally, we will map to the [termite MAGs](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA560329/). 

You must be in the Analysis folder before calling any of the Pathoscope scripts.
```
cd Analysis
```
Replace the 1-25 in the array line with 1-33 for these samples.
### **_Mapping to Human_**
You will need the [`pathoscope_termite.sh`](scripts/pathoscope_termite.sh) file. This file is set up to run 33 samples. You can change this manually and then run `sbatch ../scripts/pathoscope_termite.sh` or you can delete the line that says "#SBATCH --array=1-25" and run the following command.

```
sbatch -a 1-$(wc -l < ../samps.txt) ../scripts/pathoscope_termite.sh
```

### **_Mapping to Bacteria_**
You will need the [`pathoscope_bacteria.sh`](pathoscope_bacteria.sh) file.
This file is set up to run 33 samples. You can change this manually and then run `sbatch pathoscope_human.sh` or you can delete the line that says "#SBATCH --array=1-33" and run the following command.

Note: I'm not sure that the most recent version of the NCBI database is complete, so I'm also repeating pathoscope with an older (march 2020) database. I'll call this one bac2.
```
sbatch -a 1-$(wc -l < ../samps.txt) ../scripts/pathoscope_bacteria.sh
```

In both of these files you will see the same format:
1. Make a directory for the files.
2. Load the software needed.
3. Call PathoScope MAP
    - This maps the reads to the genomes in the databases that we have listed. It then filters out any reads that map *better* to any of the genomes in the filter databases that we have listed.
4. Call PathoScope ID
    - This assigns taxonomic ID numbers to all of the mapped reads.
5. Removes all of the unnecessary `sam` files, because `sam` files take up a lot of room (we're talking Terabytes worth of data room).

<br />

---
---

Once finished, you need to do one more thing. 
Run the following commands. This puts all the `tsv` files from each sample into folders and then downloads them. The `tsv` files are the output from PathoID that we will take into R to visualize.

Outside of your analysis folder, make directories called `bac` and `human`
```
mkdir bac
mkdir termite
mkdir MAG
mkdir human
cd Analysis
cat ../samps.txt | while read f; do cp $f/termite/pathoid-sam-report.tsv ../termite/${f}_pathoid-sam-report.tsv ; echo $f; done
cat ../samps.txt | while read f; do cp $f/bac/pathoid-sam-report.tsv ../bac/${f}_pathoid-sam-report.tsv ; echo $f; done
cat ../samps.txt | while read f; do cp $f/MAG/pathoid-sam-report.tsv ../MAG/${f}_pathoid-sam-report.tsv ; echo $f; done
cat ../samps.txt | while read f; do cp $f/human/pathoid-sam-report.tsv ../human/${f}_pathoid-sam-report.tsv ; echo $f; done
```
From your computer, make a folder called `pathoscope_output` on box in `/Box/20210728_Clement_0268`, and copy the files from your bac and human folders to this folder.
```
mkdir pathoscope_output
rsync -avh rebeccaclement@log001.colonialone.gwu.edu:glustre/Amitermes/bac .
rsync -avh rebeccaclement@log001.colonialone.gwu.edu:glustre/Amitermes/termite .
rsync -avh rebeccaclement@log001.colonialone.gwu.edu:glustre/Amitermes/MAG .
rsync -avh rebeccaclement@log001.colonialone.gwu.edu:glustre/Amitermes/human .
```
>

Next step: [Count your pathoscope reads](count_ps_reads.md) 
