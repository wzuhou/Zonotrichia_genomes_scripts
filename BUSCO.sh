#!/bin/bash


FASTA=NWCS.softmasked.rename.fa

GFF=NWCS_augustus.hints.gff3

gffread ${GFF} -g ${FASTA} -x ${GFF}.cds.fa -y ${GFF}.protein.fa
