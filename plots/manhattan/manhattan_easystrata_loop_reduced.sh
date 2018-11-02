#!/bin/sh
#$-S /bin/sh

#$ -V

#$ -pe smp 9

#$ -l h_vmem=9G
#$ -l h_rt=120:00:00

#$ -m be
#$ -M christopher.huebel@kcl.ac.uk

#$ -o /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/plotting/manhattan


export MKL_NUM_THREADS=9
export NUMEXPR_NUM_THREADS=9
export OMP_NUM_THREADS=9

module add general/R

### miami and qqplot loop ###
 
for j in "BFPC" "FFM"; do for k in "h"; do R --vanilla < /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/plotting/manhattan/manhattan_easystrata.R ${j} ${k}; done; done

