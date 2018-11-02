
### load recent python
module add utilities/anaconda/2.5.0

#### Neuroticism_GPC2
/mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/ldsc/ldsc.py \
--rg ${1},/mnt/lustre/groups/ukbiobank/usr/chris/output/neuroticism/GWAS/one_regression/Neuroticism_GPC2.sumstats.gz \
--ref-ld-chr /mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/eur_w_ld_chr/ \
--w-ld-chr /mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/eur_w_ld_chr/ \
--out /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/rg/${2}_Neuroticism_GPC2

#### Neuroticism_SSGAC
/mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/ldsc/ldsc.py \
--rg ${1},/mnt/lustre/groups/ukbiobank/usr/chris/output/neuroticism/GWAS/one_regression/Neuroticism_SSGAC.sumstats.gz \
--ref-ld-chr /mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/eur_w_ld_chr/ \
--w-ld-chr /mnt/lustre/groups/ukbiobank/Edinburgh_Data/Software/ldscore/eur_w_ld_chr/ \
--out /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/rg/${2}_Neuroticism_SSGAC

