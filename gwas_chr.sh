#!/bin/sh
#$-S /bin/sh

#$ -V

#$ -pe smp 9

#$ -l h_vmem=9G
#$ -l h_rt=120:00:00

#$ -m be
#$ -M christopher.huebel@kcl.ac.uk

#$ -o /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/output

# qsub gwas_chr.sh 21


export MKL_NUM_THREADS=9
export NUMEXPR_NUM_THREADS=9
export OMP_NUM_THREADS=9

/mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/bgenie/v1.2/bgenie_v1.2_static1 --bgen /mnt/lustre/datasets/ukbiobank/June2017/Imputed/ukb_imp_chr${1}_v2_MAF1_INFO4.bgen --pheno /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/bc_phenotypes.txt --miss NA --pvals --out /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/chr_output/bc_${1}.out --thread 9
 
