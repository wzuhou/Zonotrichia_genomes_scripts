#!/bin/bash
conda activate jcvi

#ZCAP
python -m jcvi.formats.gff bed --type=mRNA --key=ID ZCAP_augustus.hints.gff3 -o ZCAP.bed
python -m jcvi.formats.fasta format ZCAP_augustus.hints.gff3.cds.fa ZCAP.cds

#GWCS
python -m jcvi.formats.gff bed --type=mRNA --key=ID gffcmp_CXD.combined.curate2.gff3.sort.gff3.sort.mRNA_CDS.gff3 -o GWCS.bed
python -m jcvi.formats.fasta format gffcmp_CXD.combined.curate2.gff3.sort.gff3.sort.mRNA_CDS.gff3.cds.fa  GWCS.cds

#NWCS
python -m jcvi.formats.gff bed --type=mRNA --key=ID NWCS_augustus.hints.gff3 -o NWCS.bed
python -m jcvi.formats.fasta format NWCS_augustus.hints.gff3.cds.fa NWCS.cds
##############################
#manually modified the bed files
#See below

#Compare
python -m jcvi.compara.catalog ortholog GWCS ZCAP --no_strip_names #this step actually request multi-threading
python -m jcvi.compara.catalog ortholog GWCS NWCS --no_strip_names

#Dot plot
python -m jcvi.graphics.dotplot GWCS.ZCAP.anchors
python -m jcvi.graphics.dotplot GWCS.NWCS.anchors

#GWCS.ZCAP
rm GWCS.ZCAP.last.filtered 
python -m jcvi.compara.catalog ortholog GWCS ZCAP --cscore=.99 --no_strip_names
python -m jcvi.graphics.dotplot GWCS.ZCAP.anchors

#GWCS.NWCS
rm GWCS.NWCS.last.filtered 
python -m jcvi.compara.catalog ortholog GWCS NWCS --cscore=.99 --no_strip_names
python -m jcvi.graphics.dotplot GWCS.NWCS.anchors

#depth
python -m jcvi.compara.synteny depth --histogram GWCS.ZCAP.anchors
python -m jcvi.compara.synteny depth --histogram GWCS.NWCS.anchors

#simple anchor
python -m jcvi.compara.synteny screen --minspan=30 --simple GWCS.NWCS.anchors GWCS.NWCS.anchors.new 
python -m jcvi.compara.synteny screen --minspan=30 --simple GWCS.ZCAP.anchors GWCS.ZCAP.anchors.new 
#Final plot
python -m jcvi.graphics.karyotype GNZ.seqids GN.layout --keep-chrlabels --chrstyle=roundrect --font Arial --figsize 15x7 -o GNZ.karyotype.pdf
