#!/bin/bash

Contigs=/data/projects/dyao/Data/pachycara/04_hic/references/ref.fa
MND=/data/projects/dyao/Data/pachycara/04_hic/aligned/merged_nodups.txt
MAPQ=30
GAPSIZE=1000

/data/software/3d-dna-201008/run-asm-pipeline.sh -m haploid -i 100 -r 1 -q $MAPQ --sort-output -g $GAPSIZE $Contigs $MND > 3ddna.log 2>&1

