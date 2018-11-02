###a_1 -> A1 and a_0 -> A2 "swapped"

#### BFPC_af_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BFPC_af_maf0.01.txt > sex_sumstats/BFPC_af_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BFPC_af_maf0.01.txt > sex_sumstats/BFPC_af_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BFPC_af_maf0.01.txt > sex_sumstats/BFPC_af_maf0.01_male.txt

#### BFPC_c_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BFPC_c_maf0.01.txt > sex_sumstats/BFPC_c_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BFPC_c_maf0.01.txt > sex_sumstats/BFPC_c_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BFPC_c_maf0.01.txt > sex_sumstats/BFPC_c_maf0.01_male.txt


#### BFPC_h_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BFPC_h_maf0.01.txt > sex_sumstats/BFPC_h_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BFPC_h_maf0.01.txt > sex_sumstats/BFPC_h_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BFPC_h_maf0.01.txt > sex_sumstats/BFPC_h_maf0.01_male.txt


#### FFM_af_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FFM_af_maf0.01.txt > sex_sumstats/FFM_af_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FFM_af_maf0.01.txt > sex_sumstats/FFM_af_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FFM_af_maf0.01.txt > sex_sumstats/FFM_af_maf0.01_male.txt

#### FFM_c_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FFM_c_maf0.01.txt > sex_sumstats/FFM_c_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FFM_c_maf0.01.txt > sex_sumstats/FFM_c_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FFM_c_maf0.01.txt > sex_sumstats/FFM_c_maf0.01_male.txt


#### FFM_h_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FFM_h_maf0.01.txt > sex_sumstats/FFM_h_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FFM_h_maf0.01.txt > sex_sumstats/FFM_h_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FFM_h_maf0.01.txt > sex_sumstats/FFM_h_maf0.01_male.txt



#### FM_af_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FM_af_maf0.01.txt > sex_sumstats/FM_af_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FM_af_maf0.01.txt > sex_sumstats/FM_af_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FM_af_maf0.01.txt > sex_sumstats/FM_af_maf0.01_male.txt

#### FM_c_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FM_c_maf0.01.txt > sex_sumstats/FM_c_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FM_c_maf0.01.txt > sex_sumstats/FM_c_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FM_c_maf0.01.txt > sex_sumstats/FM_c_maf0.01_male.txt


#### FM_h_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' FM_h_maf0.01.txt > sex_sumstats/FM_h_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' FM_h_maf0.01.txt > sex_sumstats/FM_h_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' FM_h_maf0.01.txt > sex_sumstats/FM_h_maf0.01_male.txt



#### BMI_af_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BMI_af_maf0.01.txt > sex_sumstats/BMI_af_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BMI_af_maf0.01.txt > sex_sumstats/BMI_af_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BMI_af_maf0.01.txt > sex_sumstats/BMI_af_maf0.01_male.txt

#### BMI_c_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BMI_c_maf0.01.txt > sex_sumstats/BMI_c_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BMI_c_maf0.01.txt > sex_sumstats/BMI_c_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BMI_c_maf0.01.txt > sex_sumstats/BMI_c_maf0.01_male.txt


#### BMI_h_
awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$8,$9,$10,$11,$12}' BMI_h_maf0.01.txt > sex_sumstats/BMI_h_maf0.01_full.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$13,$14,$15,$16,$17}' BMI_h_maf0.01.txt > sex_sumstats/BMI_h_maf0.01_female.txt

awk 'BEGIN {print "chr rsid pos A1 A2 af info beta se z minus_log10p p"} NR>1 {print $1,$2,$3,$5,$4,$6,$7,$18,$19,$20,$21,$22}' BMI_h_maf0.01.txt > sex_sumstats/BMI_h_maf0.01_male.txt



