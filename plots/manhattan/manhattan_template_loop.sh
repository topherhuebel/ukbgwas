### manhattan plot template loop ###
 

for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do cp /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/plotting/manhattan_easystrata_template.ecf /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/manhattan/${j}_${k}_manhattan.ecf; done; done
 
for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do sed -i -e "s/PHENOTYPE/${j}/g" -e "s/SAMPLE/${k}/g" /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/manhattan/${j}_${k}_manhattan.ecf; done; done