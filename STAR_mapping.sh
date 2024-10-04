#!/bin/sh
# Grid Engine options
#$ -N STARmap
#$ -cwd
#$ -l h_vmem=6G
#$ -m baes
#$ -pe sharedmem 10

# If you plan to load any software modules, then you must first initialise the modules framework.
. /etc/profile.d/modules.sh
export OMP_NUM_THREADS=$NSLOTS
module load mamba/1.5.8
source activate Anno_pipeline

OUTPUT=./Output/
threads=$NSLOTS
GENOME=NWCS.softmasked.rename.fa
output=${OUTPUT}/star/
prefix=NWCS_all
index=/exports/cmvm/eddie/eb/groups/smith_grp/Zhou_wu/WCS/Annotation/NWCS_anno_pip/Output/genome/
indir=./NWCS_anno_pip/

mkdir -p ${OUTPUT}/star && cd $_

#STAR Index
#echo "
STAR --runThreadN $threads --runMode genomeGenerate --genomeDir ${index} --genomeSAindexNbases 10 --genomeFastaFiles ${GENOME}
#"

cd ${indir}
#STAR mapping
# ${prefix}_mulFQ` should be created before this script
for i in `less rna_list` ;do
##GONAD-34-NWCS-31_mulFQ
##HEART-34-NWCS-31_mulFQ
##HYP-34NWCS-31_mulFQ
##LIV-30NWCS-31_mulFQ
mytext=`cat ${i}`
prefix=`cut -c1-3 $i `
#echo "
STAR --genomeDir ${index} --runThreadN 10 --readFilesCommand zcat --readFilesIn \
 $mytext \
--outFilterType BySJout --outSAMunmapped None --outReadsUnmapped Fastx --outFileNamePrefix ${output}${prefix}. --outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 10900000000 #--outFilterScoreMinOverLread 0.3 --outFilterMatchNminOverLread 0.3 --outFilterMismatchNmax 10
#"
done
#END#
