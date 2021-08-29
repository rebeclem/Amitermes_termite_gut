## File setup
First copy all files from [Box](https://gwu.app.box.com/folder/142155909824?utm_campaign=collab%20auto%20accept%20user&utm_medium=email&utm_source=trans) to Pegasus HPC
```
rsync -avh 20210728_Clement_0268 rebeccaclement@pegasus.colonialone.gwu.edu:/groups/cbi/Users/rclement/Rawdata/
```
Navigate to the directory with the files.
Change name of directory to Amitermes with `mv 20210728_Clement_0268 Amitermes`. Pathway is /groups/cbi/Users/rclement/Rawdata.

Copy Amitermes directory to lustre for analysis: `scp -r Amitermes /lustre/groups/cbi/Users/rclement/` and navigate to that directory.

### Creating a directory for each sample.
For every file inside a folder that has a L001 and an R1, make an object samp that is the folder name. Print the folder name and then make a directory that is called the sample name with a designated prefix.
* The ${f%%-*}; is essentially calling the file name and taking out the longest possible thing that includes -* in it
```
   for f in *L001*R1*.gz;
   do samp=${f%%-*};    
   echo ${samp}; 
   mkdir -p $samp; 
   done
```
If you type `ls`, you should see a directory for each of your samples.
### Moving all sequence files into sample directory.
Move all the files into the folders that match their directory.
```
for f in *.gz;    
do samp=${f%%-*}; 
mv $f $samp; 
done
```
Each of your directories should now have 8 files that end with fastq.gz.
### Combining all NextSeq sequencing lanes into a single fastq file
```
for d in *;
     do     samp=${d%%-*};
     cat $d/*R1*.fastq.gz > $d/${samp}_R1.fastq.gz;
     cat $d/*R2*.fastq.gz > $d/${samp}_R2.fastq.gz;
     echo $samp;
 done
```
You should get a message saying that there are no .fastq.gz files or directories in the empty directories you emptied. When you finish you should have 10 total files in each directory.
### removes all the extra fastq files
```
rm */*L00?_R1*.gz
rm */*L00?_R2*.gz
```
Now you should have only two fastq.gz files in each directory.
### Remove undetermined files
```
rm *Undetermined*
```
Now you should only have the directories in the folder you're in

***
## Setting up workspace
### Make a list of samples that will be analyzed and move all directories that have more than one layer into the analysis folder
```
mkdir Analysis
find . -maxdepth 1 -type d -exec mv '{}' ./Analysis \;
```
### Make directories for your references and scripts
```
mkdir refs
mkdir scripts
```

### Move into the analysis directory and put the directory names into a file called samp.txt
```
cd Analysis
ls -d * > ../samps.txt
```

### Set up reference databases
You may have to copy over files from `/GWSPH/groups/cbi/Databases/Genomes/References` to lustre.
```
scp /GWSPH/groups/cbi/Databases/Genomes/References/Amitermes_falcatus/amiFal.* /lustre/groups/cbi/Databases/Genomes/References/Amitermes_falcatus/
```

### Build .bt2 sequences from fasta
```
module load bowtie2
bowtie2-build -f amiFal.fasta amiFal
```

### Get the most recent version of NCBI database
On an interactive node, use the following to download bt2 sequences from https://ftp.ncbi.nlm.nih.gov/blast/db/
```
. scripts/build_NCBI_refrep_genomes.sh 20210823
```

```
cd refs 
```

#### Human reference
```
for f in /lustre/groups/cbi/shared/References/Homo_sapiens/UCSC/hg38full/Sequence/Bowtie2Index/*.bt2;
 do
    ln -s $f
done
```
#### Bacteria references
```
for f in /lustre/groups/cbi/Databases/NCBI/NCBI_refrep_genomes/latest/Sequence/Bowtie2Index/*.bt2; do
ln -s $f; 
done
```
### PhiX references -include this if you have PhiX in your samples (added during sequencing)
```
for f in /lustre/groups/cbi/Databases/Genomes/References/phix/phix174/*.bt2; do 
ln -s $f;
done
```
#### Termite references - I pulled these from a few termite genomes
```
for f in /lustre/groups/cbi/Databases/Genomes/References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence/Bowtie2Index/*.bt2; do
ln -s $f;
done

for f in /lustre/groups/cbi/Databases/Genomes/References/Zootermopsis_nevadensis/BGI/zooNev/Sequence/Bowtie2Index/*.bt2; do
ln -s $f;
done

for f in /lustre/groups/cbi/Databases/Genomes/References/Amitermes_falcatus/*.bt2; do
ln -s $f;
done
```
Your refs folder should now have ~72 files that end with .bt2
You should also copy the scripts from here to your scripts folder
***
Next Step: [Perform FastQC](fastqc.md)
