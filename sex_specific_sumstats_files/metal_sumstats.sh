#!/bin/sh
#$-S /bin/sh

#$ -V

#$ -l h_vmem=4G

#$ -pe smp 1

#$ -o /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/metal/

#### BFPC_af_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bfpc/BFPC_af_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BFPC_af_maf0.01_meta.txt

#### BFPC_c_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bfpc/BFPC_c_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BFPC_c_maf0.01_meta.txt

#### BFPC_h_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bfpc/BFPC_h_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BFPC_h_maf0.01_meta.txt

#### FM_af_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/fm/FM_af_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FM_af_maf0.01_meta.txt

#### FM_c_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/fm/FM_c_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FM_c_maf0.01_meta.txt

#### FM_h_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/fm/FM_h_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FM_h_maf0.01_meta.txt

#### FFM_af_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/ffm/FFM_af_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FFM_af_maf0.01_meta.txt

#### FFM_c_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/ffm/FFM_c_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FFM_c_maf0.01_meta.txt

#### FFM_h_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/ffm/FFM_h_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/FFM_h_maf0.01_meta.txt

#### BMI_af_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bmi/BMI_af_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BMI_af_maf0.01_meta.txt

#### BMI_c_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bmi/BMI_c_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BMI_c_maf0.01_meta.txt

#### BMI_h_
awk 'BEGIN {print "MarkerName Allele1 Allele2 Freq1 FreqSE Effect StdErr Pvalue Direction HetISq HetChiSq HetDf HetPVal chr beta_female se_female p_female beta_male se_male p_male"} NR>1 {print $1,$3,$2,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14/2,$15/2,$16/2,$17/2,$18/2,$19/2,$20/2}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/metal/bmi/BMI_h_metal_se1.TBL > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/BMI_h_maf0.01_meta.txt

