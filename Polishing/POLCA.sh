#!/bin/bash
# Grid Engine options
#$ -N ZPOLCA
#$ -cwd
#$ -l h_vmem=16G
#$ -m baes
#$ -pe sharedmem 16
#$ -l rl9=true

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
export OMP_NUM_THREADS=$NSLOTS
module load mamba/1.5.8
source activate py37
module load roslin/bwa/0.7.18

#export TMPDIR=/tmp/
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/htslib/htslib-1.20/bin/"
export PATH="$PATH:/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/Install/samtools-1.2/samtools-1.20/bin/"

#bwa index draft.fasta
input=Z_capensis_rename.fa
#Z_capensis_rename.fa
#read1=171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_1.fastq.gz
#read2=171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_2.fastq.gz
#read3=171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_1.fastq.gz
#read4=171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_2.fastq.gz

polca.sh -a ${input} -r '171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_1.fastq.gz 171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_2.fastq.gz 171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_1.fastq.gz 171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_2.fastq.gz' -t 16 -m 8G

#END#
