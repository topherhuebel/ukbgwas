#!/bin/bash
#$ -cwd
#S -j y
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q
#$ -M christopher.huebel@kcl.ac.uk
#$ -m beas
#$ -l h_vmem=10G

module add general/R

for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do R --vanilla < /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/sex_specific_sumstats_files/add_pos_to_meta_sumstats.R ${j} ${k} ; done; done

