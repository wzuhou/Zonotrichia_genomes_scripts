#!/bin/bash
#$ -N Pilon
#$ -cwd
#$ -l h_vmem=12G
#$ -m baes
#$ -pe sharedmem 10
#$ -l h_rt=168:00:00

. /etc/profile.d/modules.sh
export OMP_NUM_THREADS=$NSLOTS
module load roslin/bwa/0.7.16a
module load java
module load roslin/samtools/1.10

input=Z_capensis_rename.fa
read1=171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_1.fastq.gz
read2=171103_E00397_0080_BH3W23CCXY_1_TP-D7-011_2.fastq.gz
read3=171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_1.fastq.gz
read4=171103_E00397_0080_BH3W23CCXY_2_TP-D7-011_2.fastq.gz
threads=$NSLOTS
mkdir -p Z_Pilon

# Index fasta
bwa index ${input}
samtools faidx ${input}

# Mapping
bwa mem -R "@RG\tID:Zcapensis_1\tSM:Zcap\tPL:Illumina\tLB:ZCap\tPU:unkn-0.0" -t ${threads} ${input} ${read1} ${read2}|samtools view --threads $threads -b -|samtools fixmate -m --threads 3 - -|samtools sort -m 8g --threads 5 -|samtools markdup --threads 5 -r - Z_Pilon/sgs1.sort.bam
# Align and process read pairs 3 and 4
bwa mem -R "@RG\tID:Z_capensis_2\tSM:ZCap\tPL:Illumina\tLB:ZCap\tPU:unkn-0.0"  -t ${threads} ${input} ${read3} ${read4} | samtools view --threads $threads -b - | samtools fixmate -m --threads 3 - - | samtools sort -m 8g --threads 5 - | samtools markdup --threads 5 -r - Z_Pilon/sgs2.sort.bam

bam1=Z_Pilon/sgs1.sort.bam
bam2=Z_Pilon/sgs2.sort.bam
samtools index -@ $threads $bam1
samtools index -@ $threads $bam2
#samtools faidx $input
java -Xmx100G -jar ./Install/pilon-1.24.jar --genome ${input} --frags ${bam1} --frags ${bam2} --output ${input}.Pilon.fa --outdir ./Z_Pilon --chunksize 25000000 --threads $threads --verbose
