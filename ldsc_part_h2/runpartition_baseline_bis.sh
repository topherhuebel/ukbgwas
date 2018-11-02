#!/bin/bash
#$ -cwd
#S -j y
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q
#$ -M christopher.huebel@kcl.ac.uk
#$ -m beas
#$ -l h_vmem=10G
#$ -o /mnt/lustre/groups/ukbiobank/usr/chris/gwasan/cojo_multitrait

### post mtCOJO clumping
### Christopher Hübel
### 08.03.2018

#./runpartition.sh outputdir PHENO


input=$1
outputdir=$2
name=$3
ldscdir=/mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/ldsc


~/.conda/envs/myenv/bin/python ${ldscdir}/ldsc.py --h2 $input --ref-ld-chr ${ldscdir}/1000G_EUR_Phase3_baseline/baseline. --w-ld-chr ${ldscdir}/weights_hm3_no_hla/weights. --overlap-annot --frqfile-chr ${ldscdir}/1000G_Phase3_frq/1000G.EUR.QC. --out ${outputdir}/${name}.baseline --print-coefficients;
