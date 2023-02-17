#! /bin/bash

umask 0002

# Load modules
module load bowtie2
module load python3

# Get the repository root directory
cd /groups/cbi/Databases/Genomes/
EMAIL='rebeccaclement@gwu.edu'


### Pull Seqs from NCBI #####################################
### You have to make sure that there is an archive folder
### mkdir -p Archive && cd Archive

# put the fasta file here with 30,000+ accessions
#We pulled accession numbers from here: https://www.ncbi.nlm.nih.gov/Traces/wgs/CEME01?display=contigs

# Put accession numbers into this file: nasExit.txt
# Edit the python script nasute_fasta_from_acc.py so that the taxon ID is the taxon ID from NCBI (114634).
#Run the python script
python ../../scripts/nasute_fasta_from_acc.py --email rebeccaclement@gwu.edu nasExit.txt > nasExi.fa
#Do a quick line count
cat nasExi.fa |wc -l

# split into more manageable size files for entrez. Don't need to do this bc there are only
#split -l 150 -d nasExit.txt nasute
#for f in nasute*; do
#    echo $f
#    python3 ../scripts/termite_fasta_from_acc.py --email $EMAIL $f > out.${f}
#    grep "^>" out.${f} | wc -l
#    echo
#    sleep 3s
#done

#cat out.znev* > zooNev.fa
#rm out.znev*
#rm znev*

cd ..

### Create assembly directory ############################################################
mkdir -p References/Nasutitermes_exitiosus/NCBI/nasExi

### Create Sequence subdirectory #########################################################
mkdir -p References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence

### Create Sequence/WholeGenomeFasta subdirectory ########################################
mkdir -p References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence/WholeGenomeFasta
mkdir -p References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence/Bowtie2Index

### Move reference sequence #############################################################
mv Archive/nasExi.fa References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence/WholeGenomeFasta/nasExi.fa

# run this in the Genomes folder
### Build Bowtie2 index ##################################################################
sbatch -N 1 -t 480 -p short,tiny,defq <<EOF
#! /bin/bash
umask 0002
module load tbb
module load bowtie2/2.3.4.3
cd References/Nasutitermes_exitiosus/NCBI/nasExi/Sequence/Bowtie2Index
[[ ! -e zooNev.fa ]] && ln -s ../WholeGenomeFasta/nasExi.fa
bowtie2-build nasExi.fa nasExi

EOF
