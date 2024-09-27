#!/bin/sh
# Grid Engine options
#$ -N Nucmer
#$ -cwd
#$ -l h_vmem=12G
#$ -pe sharedmem 4
#$ -m baes

# Choose the staging environment
export OMP_NUM_THREADS=$NSLOTS
export PATH="$PATH:/exports/./Install/MUMmer3.23/"
export PATH="$PATH:/exports/./Install/dotPlotly-master/"

input2=./WCS/Genome_WCS/Fasta/
prefix=ZCAP.softmasked.fasta

input1=GWCS.softmasked.fasta
nucmer  ${input1} ${input2}/${prefix}  -p fixed_${prefix}_ZvsG -l 80 -c 100
delta-filter  -i 30 -m fixed_${prefix}_ZvsG.delta > fixed_${prefix}_ZvsG_i30_m.filter
show-coords -c -I 30 -q fixed_${prefix}_ZvsG_i30_m.filter > fixed_${prefix}_ZvsG_i30_m.filter.coords

#END#
