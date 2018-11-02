#!/bin/bash
#$ -cwd
#S -j y
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q
#$ -m beas
#$ -l h_vmem=10G

/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh BFPC c 180765 173207 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh BFPC h 91412 99750 191162

/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh BMI c 180765 173207 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh BMI h 91412 99750 191162

/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh FFM c 180765 173207 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_bc_500k.sh FFM h 91412 99750 191162



/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh BFPC c 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh BFPC h 191162

/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh BMI c 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh BMI h 191162

/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh FFM c 353972
/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/ldsr/munging_metal.sh FFM h 191162



