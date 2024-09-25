#!/bin/bash

cd ./WCS/comparative_genome/Fasta

cat Z_capensis.fasta | seqkit replace --ignore-case --keep-key --line-width 0 --kv-file < (cat Z_capensis.fasta.fai.rename) --pattern "(.+)" --replacement "{kv}" > Z_capensis_rename.fa

#END#
