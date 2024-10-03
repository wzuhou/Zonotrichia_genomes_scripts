#!/bin/bash
# Make Snail plot locally
cd ./Zcap

blobtools create \
    --fasta ZCAP.softmasked.fasta \
   ZCAP_snail_plot

#Add BUSCO   
# cd ..
blobtools add --busco ./run_aves_odb10/full_table.tsv  ZCAP_snail_plot

#View
#blobtools view --local _
cd ZCAP_snail_plot
blobtools view   --view snail  --plot --local --out ./  --prefix Z.Capensis  ./
mv .snail.png Zcap.snail.png
#END#
