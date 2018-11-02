#### significant SNPs

#### sex-specific
for file in /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/*e.txt; 
do
		name=${file##*/}
        base=${name%.txt}
        awk '{if(($12 <= 0.00000005) || (NR == 1)){print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}}' ${file} > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sign_snps/"${base}_signsnps.txt"; done

#### metal

for file in /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/*meta_pos.txt; do
		name=${file##*/}
        base=${name%.txt}
        awk 'BEGIN { FS = "\t" }{if(($8 <= 0.00000005) || (NR == 1)){print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25}}' ${file} > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sign_snps/"${base}_signsnps.txt"; done


#### full
for file in /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/*ll.txt; 
do
		name=${file##*/}
        base=${name%.txt}
        awk '{if(($12 <= 0.00000005) || (NR == 1)){print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}}' ${file} > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sign_snps/"${base}_signsnps.txt"; done