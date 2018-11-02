

### miami and qqplot loop ###
 

for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do cp /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/plotting/miami/miami_template.ecf /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/${j}_${k}_miami.ecf; done; done
 
for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do sed -i -e "s/PHENOTYPE/${j}/g" -e "s/SAMPLE/${k}/g" /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/${j}_${k}_miami.ecf; done; done

for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do cp /mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/plotting/miami/qq_template.ecf /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/${j}_${k}_qq.ecf; done; done
 
for j in "BFPC" "BMI" "FFM" "FM"; do for k in "c" "h" "af"; do sed -i -e "s/PHENOTYPE/${j}/g" -e "s/SAMPLE/${k}/g" /mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/${j}_${k}_qq.ecf; done; done

