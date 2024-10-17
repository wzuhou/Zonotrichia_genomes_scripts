#!/bin/bash

FASTA=NWCS.softmasked.rename.fa
GFF=NWCS_augustus.hints.gff3

#gffread
gffread ${GFF} -g ${FASTA} -x ${GFF}.cds.fa -y ${GFF}.protein.fa

#BUSCO
fa=NWCS_augustus.hints.gff3.cds.fa
AVal=NWCS_braker

#aves
busco -i ${fa} -o ${AVal}_aves_busco --out_path ./Busco_out_trans -m transcriptome -l aves_odb10 -c 8 -f
#END#
