#! /bin/bash

# Run this script line by line to build bowtie indices from the most recent NCBI refrep genomes. 

[[ -n ${1+x} ]] && build=$1
[[ -z ${build+x} ]] && build=$(date +"%Y%m%d")

# Load modules
module load blast+
module load bowtie2
module load pigz

# Get the repository root directory
dbroot="/GWSPH/groups/cbi/Databases"

# Function for checking bowtie2 indexes
checkindex () {
    local prefix=$1
    [[ ! -e ${prefix}.1.bt2 ]] && return 1
    [[ ! -e ${prefix}.2.bt2 ]] && return 1
    [[ ! -e ${prefix}.3.bt2 ]] && return 1
    [[ ! -e ${prefix}.4.bt2 ]] && return 1
    [[ ! -e ${prefix}.rev.1.bt2 ]] && return 1
    [[ ! -e ${prefix}.rev.2.bt2 ]] && return 1
    bowtie2-inspect -n $prefix &> /dev/null
    [[ $? -ne 0 ]] && return 1
    return 0
}

#--- Create and move to build directory
builddir=$dbroot/NCBI/NCBI_refrep_genomes/$build
mkdir -p $builddir && cd $builddir
mkdir -p Archive

#--- Download rep_genome databses from NCBI
rsync --partial --progress -iav ftp.ncbi.nlm.nih.gov::blast/db/ref_p*_rep_genomes*.tar.gz* Archive/
rsync --partial --progress -iav ftp.ncbi.nlm.nih.gov::blast/db/ref_v*_rep_genomes*.tar.gz* Archive/

# Check md5sum 
cd Archive
for f in ref*.md5; do 
    md5sum -c $f
done
cd ..

#--- Process each database
for f in Archive/*.tar.gz; do
    prefix=$(basename $f | sed 's/\.tar\.gz$//')

    #--- Check whether we already have the bowtie2 index
    checkindex "${prefix}_ti"
    if [[ $? -eq 0 ]]; then
        echo "$prefix index found"
    else
        echo "Running $prefix"
        #--- Unzip
        echo "Unzipping..."
        tar -I pigz -xf $f
        #--- Create FASTA file with taxa id
        echo "Extracting FASTA..."
        blastdbcmd -db $prefix -entry all -out - -outfmt ">ti|%T|gi|%g|ref|%a| %t##X##%s" | \
            perl -lne '($d,$s)=split /##X##/,$_,2;($w=$s)=~s/(.{0,80})/$1\n/g;print "$d\n$w"'| \
            grep -v '^$' > ${prefix}_ti.fna

        #--- Get rid of the BLAST files
        rm $prefix.n*

        #--- Submit job to build index
        sbatch -t 2880 -p short,tiny,defq,small-gpu -N 1 \
            --export ref=${prefix}_ti.fna,out=${prefix}_ti \
           $dbroot/scripts/bowtie2build_wrapper.sh
    fi
done


#--- remove unnecessary files and move around files to organize
rm *genomes.n*
rm slurm*

mkdir -p $builddir/Annotations
mv tax* $builddir/Annotations/
mkdir -p $builddir/Sequence/WholeGenomeFasta
mkdir -p $builddir/Sequence/Bowtie2Index
mv *.fna $builddir/Sequence/WholeGenomeFasta/
mv *.bt2 $builddir/Sequence/Bowtie2Index/


echo -e '*\n!.gitignore' > .gitignore
