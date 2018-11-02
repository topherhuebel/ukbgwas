#### maf 0.01 filtering

#### BFPC healthy

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_h.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_h_maf0.01.txt

#### BFPC complete

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_c.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_c_maf0.01.txt

#### BFPC anfree

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_af.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BFPC_af_maf0.01.txt


#### BMI healthy

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_h.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_h_maf0.01.txt

#### BMI complete

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_c.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_c_maf0.01.txt

#### BMI anfree

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_af.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/BMI_af_maf0.01.txt


#### FFM healthy

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_h.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_h_maf0.01.txt

#### FFM complete

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_c.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_c_maf0.01.txt

#### FFM anfree

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_af.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FFM_af_maf0.01.txt


#### FM healthy

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_h.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_h_maf0.01.txt

#### FM complete

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_c.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_c_maf0.01.txt

#### FM anfree

#### SNPs MAF >= 0.01
awk '{if(($6 >= 0.01) && ($6 <= 0.99) || (NR == 1)){print}}' /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_af.txt > /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/FM_af_maf0.01.txt

