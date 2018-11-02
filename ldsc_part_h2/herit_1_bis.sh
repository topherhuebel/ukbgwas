input=$1
outputdir=$2
name=$3

qsub /mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/runpartition_baseline_bis.sh ${input} ${outputdir} ${name}
qsub /mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/runpartition2_a_bis.sh ${input} ${outputdir} ${name} 
qsub /mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/runpartition2_b_bis.sh ${input} ${outputdir} ${name} 
qsub /mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/runpartition2_c_bis.sh ${input} ${outputdir} ${name} 
