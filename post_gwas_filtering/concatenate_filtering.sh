cd /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/chr_output


### unzip
gunzip *.gz

##### identify duplicates in bc

#### generate duplicate list per chromosome
for i in `seq 1 22`; do awk 'seen[$2]++ {print$2}' bc_${i}.out > bc_${i}_duplicates.out; done

#### delete duplicates
for i in `seq 1 22`; do LANG=C fgrep -w -v -f bc_${i}_duplicates.out bc_${i}.out > bc_${i}_without_duplicates.out; done

#### delete non_hrc
for i in `seq 1 22`; do LANG=C fgrep -w -f /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/hrc_snps/SNPs_In_HRC_Or_Genotyped_Chr${i}_list.txt bc_${i}_without_duplicates.out > bc_${i}_without_duplicates_hrc.out; done

