# Performing FastQC on samples to assess the quality of reads
Alternatively, you can use [this script](fastqc.sh) to run it on the cluster after making a directory called "outfastqc" in the Analysis folder

```
cd Analysis
```
Call FastQC on the raw sequence files.
```
module use /groups/cbi/shared/modulefiles
module load fastqc
for f in *; do
    fastqc -o $f -f fastq $f/${f}_R1.fastq.gz $f/${f}_R2.fastq.gz
done
```
If you do not have access to the module files in CBI, instead, run the following:
`module load fastQC`
followed by
`module list` to make sure you can load fastQC.
Then, run:
```
for f in *; do
    fastqc -o $f -f fastq $f/${f}_R1.fastq.gz $f/${f}_R2.fastq.gz
done
```
in your analysis folder.

You will get two output files for each fastq files (.html and .zip):

<br />

The `html` files are the ones that we are interested in. We're going to delete all of the zip files in the folder so we have just the `html` files.
```
# remember we're still in the Analysis folder
rm */*_R?_fastqc.zip
```
Now download that folder to your computer with this command. This command needs to be excuted on your local computer (not within colonial one). I recommend opening up another tab on your terminal and then executing this command:
```
scp your_username@login.colonialone.edu:path/to/Analysis/fastqc_raw /local/dir
```
>You will need to replace a few things. As an example for you, I have used my path and username.
>
>| your_username | path/to/Analysis | local/dir |
>| --- | --- | --- |
>| rebeccaclement | /lustre/meni/Analysis | ~/Downloads/meni |
>

<br />
Also upload the files to [GW BOX](https://gwu.app.box.com/folder/142719820510)

All of the files can be opened up through Safari/Chrome/etc. (whatever internet browser you use). If you open the downloaded folder in your Finder (if on mac), you can select a file (so it is highlighted) and press the *space* button. A temporary window should show up with your results. Now you can press the *down arrow* and scroll through all the files relatively quickly.

See this [PDF](https://github.com/kmgibson/EV_konzo/blob/master/FastQC_Manual.pdf) explaining the FastQC results or this [website by the creators of FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) that also has explaination of the results. 
- The PDF was downloaded from the [University of Missouri sequencing core](https://dnacore.missouri.edu).


<br />

---
Next step: Use [flexbar](flexbar.md) to trim sequences
