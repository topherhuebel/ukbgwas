##### Exclusion, Descriptives ########

#### load libraries
library(fBasics)
library(dplyr)
library(data.table)
library(grDevices)


#### Genotypes ####
### import
#genotypes <- fread(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Genotypes/Chris_July_2017/ukb2754_imp_chr1_v2_s487398.sample", header = TRUE)
#genotypes$missing <- NULL
#genotypes$ID_2 <- NULL
### add index column
#genotypes$gen_ID<-seq.int(nrow(genotypes))
#nrow(genotypes)


#### Leftover individuals IDs after quality control #####
#### MAF0.01_GENO0.02_MIND0.02_CAUC1_UKBQC1_UNREL0.044_HWE0.00000001_SEX1
### import fam file for IDs
fam_sex_combined <- fread(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Genotypes/Chris_July_2017/qc_set/ukb2754_MAF0.01_GENO0.02_MIND0.02_CAUC1_UKBQC1_UNREL0.044_HWE0.00000001_SEX1.fam", header = TRUE)
### set colnames
colnames(fam_sex_combined) <- c("FID", "IID", "father", "mother", "Passed_QC_both", "Phenotype")
### delete unnecessary columns
fam_sex_combined$FID <- NULL
fam_sex_combined$father <- NULL
fam_sex_combined$mother <- NULL
fam_sex_combined$Phenotype <- NULL
dim(fam_sex_combined)
# 385752      2
head(fam_sex_combined)
# IID Passed_QC_both
# 1: 4439466              2
# 2: 3643257              2
summary(fam_sex_combined)
# IID          Passed_QC_both
# Min.   :    -11   Min.   :0.00
# 1st Qu.:2254439   1st Qu.:1.00
# Median :3512300   Median :2.00
# Mean   :3512216   Mean   :1.54
# 3rd Qu.:4770298   3rd Qu.:2.00
# Max.   :6026196   Max.   :2.00


#### merge genotypes and passed QC
#genotypes_qc <- merge(genotypes, fam_sex_combined, by.x="ID_1", by.y="IID", all = FALSE, sort = FALSE)
#colnames(genotypes_qc) <- c("IID", "gen_ID", "Passed_QC_both")
#nrow(genotypes_qc)


##### copy quality-controlled IDs into new dataframe because we did not merge with .sample-file
genotypes_qc <- fam_sex_combined


#### Phenotypes from larger UKBB file including MHQ #####
### import the phenotypes which you did awk from the larger UKBB file
phenotypes <- fread(file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/ed_cases/mhq_diagnoses.txt", header = TRUE)
### set colnames
colnames(phenotypes) <- c("IID", "Gender", "Age", 
                          "Menopause", "SES", "Centre", 
                          "Current_tobacco", "Alcohol_frequency", 
                          "Weight", "BMI", "FFM", "FM", "BFPC", "Height", "WC", "HC", 
                          "Pregnant", 
                          "MHQ1", "MHQ2", "MHQ3", "MHQ4", "MHQ5", 
                          "MHQ6", "MHQ7", "MHQ8", "MHQ9",  "MHQ10", 
                          "MHQ11", "MHQ12", "MHQ13", "MHQ14", 
                          "MHQ15", "MHQ16", "MHQ_help")
### MHQ_help coding
# -818	Prefer not to answer
# -121	Do not know
# 0	No
# 1	Yes
### calculate waist-to-hip ratio
phenotypes$WHR <- phenotypes$WC/phenotypes$HC
### number of columns
ncol(phenotypes)
# 35
### merge quality-controlled IDs with the extrated phenotypes
genotypes_qc_phenotypes <- merge(genotypes_qc, phenotypes, all = FALSE, sort = FALSE)
### sanity check, rown numbers should always be the same
dim(genotypes_qc_phenotypes)
# 385742     36
summary(genotypes_qc_phenotypes)
# IID          Passed_QC_both     Gender            Age
# Min.   :1000015   Min.   :1.00   Min.   :0.0000   Min.   :38.00
# 1st Qu.:2254518   1st Qu.:1.00   1st Qu.:0.0000   1st Qu.:50.00
### phenotype colmuns which are factors
phenotypes_factors <- c("IID", "Passed_QC_both", "Gender", "Menopause", 
                        "Centre", "Current_tobacco", "Alcohol_frequency", 
                        "Pregnant", "MHQ1", "MHQ2", "MHQ3", 
                        "MHQ4", "MHQ5", "MHQ6", "MHQ7", "MHQ8", "MHQ9", 
                        "MHQ10", "MHQ11", "MHQ12", "MHQ13", "MHQ14", 
                        "MHQ15", "MHQ16", "MHQ_help")
### convert data.table to data.frame
genotypes_qc_phenotypes <- as.data.frame(genotypes_qc_phenotypes)
### change columns from numeric into factors
genotypes_qc_phenotypes[phenotypes_factors] <- lapply(genotypes_qc_phenotypes[phenotypes_factors], factor)
### sanity check
summary(genotypes_qc_phenotypes)


### identify AN cases
genotypes_qc_phenotypes["Anorexia_nervosa"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Anorexia_nervosa[MHQ1 == 16 | MHQ2 == 16 | MHQ3 == 16 | MHQ4 == 16 | MHQ5 == 16 | MHQ6 == 16 | MHQ7 == 16 | MHQ8 == 16 | MHQ9 == 16 | MHQ10 == 16 | MHQ11 == 16 | MHQ12 == 16 | MHQ13 == 16 | MHQ14 == 16 | MHQ15 == 16 | MHQ16 == 16 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Anorexia_nervosa[is.na(Anorexia_nervosa) ] <- 0) 
genotypes_qc_phenotypes$Anorexia_nervosa <- as.factor(genotypes_qc_phenotypes$Anorexia_nervosa)
summary(genotypes_qc_phenotypes$Anorexia_nervosa)
# 0      1
# 385010    732
### identify BN cases
genotypes_qc_phenotypes["Bulimia_nervosa"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Bulimia_nervosa[MHQ1 == 12 | MHQ2 == 12 | MHQ3 == 12 | MHQ4 == 12 | MHQ5 == 12 | MHQ6 == 12 | MHQ7 == 12 | MHQ8 == 12 | MHQ9 == 12 | MHQ10 == 12 | MHQ11 == 12 | MHQ12 == 12 | MHQ13 == 12 | MHQ14 == 12 | MHQ15 == 12 | MHQ16 == 12 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Bulimia_nervosa[is.na(Bulimia_nervosa) ] <- 0) 
genotypes_qc_phenotypes$Bulimia_nervosa <- as.factor(genotypes_qc_phenotypes$Bulimia_nervosa)
summary(genotypes_qc_phenotypes$Bulimia_nervosa)
# 0      1
# 385333    409
### identify Social anxiety cases
genotypes_qc_phenotypes["Social_anxiety"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Social_anxiety[MHQ1 == 1 | MHQ2 == 1 | MHQ3 == 1 | MHQ4 == 1 | MHQ5 == 1 | MHQ6 == 1 | MHQ7 == 1 | MHQ8 == 1 | MHQ9 == 1 | MHQ10 == 1 | MHQ11 == 1 | MHQ12 == 1 | MHQ13 == 1 | MHQ14 == 1 | MHQ15 == 1 | MHQ16 == 1 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Social_anxiety[is.na(Social_anxiety) ] <- 0) 
genotypes_qc_phenotypes$Social_anxiety <- as.factor(genotypes_qc_phenotypes$Social_anxiety)
summary(genotypes_qc_phenotypes$Social_anxiety)
# 0      1
# 384172   1570
### identify Schizophrenia cases
genotypes_qc_phenotypes["Schizophrenia"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Schizophrenia[MHQ1 == 2 | MHQ2 == 2 | MHQ3 == 2 | MHQ4 == 2 | MHQ5 == 2 | MHQ6 == 2 | MHQ7 == 2 | MHQ8 == 2 | MHQ9 == 2 | MHQ10 == 2 | MHQ11 == 2 | MHQ12 == 2 | MHQ13 == 2 | MHQ14 == 2 | MHQ15 == 2 | MHQ16 == 2 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Schizophrenia[is.na(Schizophrenia) ] <- 0) 
genotypes_qc_phenotypes$Schizophrenia <- as.factor(genotypes_qc_phenotypes$Schizophrenia)
summary(genotypes_qc_phenotypes$Schizophrenia)
# 0      1
# 385630    112
### identify Psychosis cases
genotypes_qc_phenotypes["Psychosis"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psychosis[MHQ1 == 3 | MHQ2 == 3 | MHQ3 == 3 | MHQ4 == 3 | MHQ5 == 3 | MHQ6 == 3 | MHQ7 == 3 | MHQ8 == 3 | MHQ9 == 3 | MHQ10 == 3 | MHQ11 == 3 | MHQ12 == 3 | MHQ13 == 3 | MHQ14 == 3 | MHQ15 == 3 | MHQ16 == 3 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psychosis[is.na(Psychosis) ] <- 0) 
genotypes_qc_phenotypes$Psychosis <- as.factor(genotypes_qc_phenotypes$Psychosis)
summary(genotypes_qc_phenotypes$Psychosis)
# 0      1
# 385260    482
### identify Personality_disorder cases
genotypes_qc_phenotypes["Personality_disorder"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Personality_disorder[MHQ1 == 4 | MHQ2 == 4 | MHQ3 == 4 | MHQ4 == 4 | MHQ5 == 4 | MHQ6 == 4 | MHQ7 == 4 | MHQ8 == 4 | MHQ9 == 4 | MHQ10 == 4 | MHQ11 == 4 | MHQ12 == 4 | MHQ13 == 4 | MHQ14 == 4 | MHQ15 == 4 | MHQ16 == 4 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Personality_disorder[is.na(Personality_disorder) ] <- 0) 
genotypes_qc_phenotypes$Personality_disorder <- as.factor(genotypes_qc_phenotypes$Personality_disorder)
summary(genotypes_qc_phenotypes$Personality_disorder)
# 0      1
# 385439    303


### identify Phobia cases
genotypes_qc_phenotypes["Phobia"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Phobia[MHQ1 == 5 | MHQ2 == 5 | MHQ3 == 5 | MHQ4 == 5 | MHQ5 == 5 | MHQ6 == 5 | MHQ7 == 5 | MHQ8 == 5 | MHQ9 == 5 | MHQ10 == 5 | MHQ11 == 5 | MHQ12 == 5 | MHQ13 == 5 | MHQ14 == 5 | MHQ15 == 5 | MHQ16 == 5 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Phobia[is.na(Phobia) ] <- 0) 
genotypes_qc_phenotypes$Phobia <- as.factor(genotypes_qc_phenotypes$Phobia)
summary(genotypes_qc_phenotypes$Phobia)
# 0      1
# 384031   1711
### identify Panic_attacks cases
genotypes_qc_phenotypes["Panic_attacks"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Panic_attacks[MHQ1 == 6 | MHQ2 == 6 | MHQ3 == 6 | MHQ4 == 6 | MHQ5 == 6 | MHQ6 == 6 | MHQ7 == 6 | MHQ8 == 6 | MHQ9 == 6 | MHQ10 == 6 | MHQ11 == 6 | MHQ12 == 6 | MHQ13 == 6 | MHQ14 == 6 | MHQ15 == 6 | MHQ16 == 6 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Panic_attacks[is.na(Panic_attacks) ] <- 0) 
genotypes_qc_phenotypes$Panic_attacks <- as.factor(genotypes_qc_phenotypes$Panic_attacks)
summary(genotypes_qc_phenotypes$Panic_attacks)
# 0      1
# 378719   7023
### identify OCD cases
genotypes_qc_phenotypes["OCD"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, OCD[MHQ1 == 7 | MHQ2 == 7 | MHQ3 == 7 | MHQ4 == 7 | MHQ5 == 7 | MHQ6 == 7 | MHQ7 == 7 | MHQ8 == 7 | MHQ9 == 7 | MHQ10 == 7 | MHQ11 == 7 | MHQ12 == 7 | MHQ13 == 7 | MHQ14 == 7 | MHQ15 == 7 | MHQ16 == 7 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, OCD[is.na(OCD) ] <- 0) 
genotypes_qc_phenotypes$OCD <- as.factor(genotypes_qc_phenotypes$OCD)
summary(genotypes_qc_phenotypes$OCD)
# 0      1
# 384970    772
### identify BIP_Mania cases
genotypes_qc_phenotypes["BIP_Mania"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, BIP_Mania[MHQ1 == 10 | MHQ2 == 10 | MHQ3 == 10 | MHQ4 == 10 | MHQ5 == 10 | MHQ6 == 10 | MHQ7 == 10 | MHQ8 == 10 | MHQ9 == 10 | MHQ10 == 10 | MHQ11 == 10 | MHQ12 == 10 | MHQ13 == 10 | MHQ14 == 10 | MHQ15 == 10 | MHQ16 == 10 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, BIP_Mania[is.na(BIP_Mania) ] <- 0) 
genotypes_qc_phenotypes$BIP_Mania <- as.factor(genotypes_qc_phenotypes$BIP_Mania)
summary(genotypes_qc_phenotypes$BIP_Mania)
# 0      1
# 385081    661
### identify Depression cases
genotypes_qc_phenotypes["Depression"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Depression[MHQ1 == 11 | MHQ2 == 11 | MHQ3 == 11 | MHQ4 == 11 | MHQ5 == 11 | MHQ6 == 11 | MHQ7 == 11 | MHQ8 == 11 | MHQ9 == 11 | MHQ10 == 11 | MHQ11 == 11 | MHQ12 == 11 | MHQ13 == 11 | MHQ14 == 11 | MHQ15 == 11 | MHQ16 == 11 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Depression[is.na(Depression) ] <- 0) 
genotypes_qc_phenotypes$Depression <- as.factor(genotypes_qc_phenotypes$Depression)
summary(genotypes_qc_phenotypes$Depression)
# 0      1
# 358750  26992
### identify BED cases
genotypes_qc_phenotypes["BED"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, BED[MHQ1 == 13 | MHQ2 == 13 | MHQ3 == 13 | MHQ4 == 13 | MHQ5 == 13 | MHQ6 == 13 | MHQ7 == 13 | MHQ8 == 13 | MHQ9 == 13 | MHQ10 == 13 | MHQ11 == 13 | MHQ12 == 13 | MHQ13 == 13 | MHQ14 == 13 | MHQ15 == 13 | MHQ16 == 13 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, BED[is.na(BED) ] <- 0) 
genotypes_qc_phenotypes$BED <- as.factor(genotypes_qc_phenotypes$BED)
summary(genotypes_qc_phenotypes$BED)
# 0      1
# 385181    561


### identify Autism cases
genotypes_qc_phenotypes["Autism"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Autism[MHQ1 == 14 | MHQ2 == 14 | MHQ3 == 14 | MHQ4 == 14 | MHQ5 == 14 | MHQ6 == 14 | MHQ7 == 14 | MHQ8 == 14 | MHQ9 == 14 | MHQ10 == 14 | MHQ11 == 14 | MHQ12 == 14 | MHQ13 == 14 | MHQ14 == 14 | MHQ15 == 14 | MHQ16 == 14 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Autism[is.na(Autism) ] <- 0) 
genotypes_qc_phenotypes$Autism <- as.factor(genotypes_qc_phenotypes$Autism)
summary(genotypes_qc_phenotypes$Autism)
# 0      1
# 385556    186
### identify GAD cases
genotypes_qc_phenotypes["GAD"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, GAD[MHQ1 == 15 | MHQ2 == 15 | MHQ3 == 15 | MHQ4 == 15 | MHQ5 == 15 | MHQ6 == 15 | MHQ7 == 15 | MHQ8 == 15 | MHQ9 == 15 | MHQ10 == 15 | MHQ11 == 15 | MHQ12 == 15 | MHQ13 == 15 | MHQ14 == 15 | MHQ15 == 15 | MHQ16 == 15 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, GAD[is.na(GAD) ] <- 0) 
genotypes_qc_phenotypes$GAD <- as.factor(genotypes_qc_phenotypes$GAD)
summary(genotypes_qc_phenotypes$GAD)
# 0      1
# 367869  17873
### identify Agoraphobia cases
genotypes_qc_phenotypes["Agoraphobia"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Agoraphobia[MHQ1 == 17 | MHQ2 == 17 | MHQ3 == 17 | MHQ4 == 17 | MHQ5 == 17 | MHQ6 == 17 | MHQ7 == 17 | MHQ8 == 17 | MHQ9 == 17 | MHQ10 == 17 | MHQ11 == 17 | MHQ12 == 17 | MHQ13 == 17 | MHQ14 == 17 | MHQ15 == 17 | MHQ16 == 17 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Agoraphobia[is.na(Agoraphobia) ] <- 0) 
genotypes_qc_phenotypes$Agoraphobia <- as.factor(genotypes_qc_phenotypes$Agoraphobia)
summary(genotypes_qc_phenotypes$Agoraphobia)
# 0      1
# 385242    500
### identify ADHD cases
genotypes_qc_phenotypes["ADHD"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, ADHD[MHQ1 == 18 | MHQ2 == 18 | MHQ3 == 18 | MHQ4 == 18 | MHQ5 == 18 | MHQ6 == 18 | MHQ7 == 18 | MHQ8 == 18 | MHQ9 == 18 | MHQ10 == 18 | MHQ11 == 18 | MHQ12 == 18 | MHQ13 == 18 | MHQ14 == 18 | MHQ15 == 18 | MHQ16 == 18 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, ADHD[is.na(ADHD) ] <- 0) 
genotypes_qc_phenotypes$ADHD <- as.factor(genotypes_qc_phenotypes$ADHD)
summary(genotypes_qc_phenotypes$ADHD)
# 0      1
# 385640    102
### identify Prefer_not_to_answer cases
genotypes_qc_phenotypes["Prefer_not_to_answer"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Prefer_not_to_answer[MHQ1 == -818 | MHQ2 == -818 | MHQ3 == -818 | MHQ4 == -818 | MHQ5 == -818 | MHQ6 == -818 | MHQ7 == -818 | MHQ8 == -818 | MHQ9 == -818 | MHQ10 == -818 | MHQ11 == -818 | MHQ12 == -818 | MHQ13 == -818 | MHQ14 == -818 | MHQ15 == -818 | MHQ16 == -818 | MHQ1 == -819 | MHQ2 == -819 | MHQ3 == -819 | MHQ4 == -819 | MHQ5 == -819 | MHQ6 == -819 | MHQ7 == -819 | MHQ8 == -819 | MHQ9 == -819 | MHQ10 == -819 | MHQ11 == -819 | MHQ12 == -819 | MHQ13 == -819 | MHQ14 == -819 | MHQ15 == -819 | MHQ16 == -819 ] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Prefer_not_to_answer[is.na(Prefer_not_to_answer) ] <- 0) 
genotypes_qc_phenotypes$Prefer_not_to_answer <- as.factor(genotypes_qc_phenotypes$Prefer_not_to_answer)
summary(genotypes_qc_phenotypes$Prefer_not_to_answer)
#      0      1
# 385316    426


### identify Psydx_mqh cases
genotypes_qc_phenotypes["Psydx_mqh"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_mqh[Anorexia_nervosa == 1 | Bulimia_nervosa == 1 | Social_anxiety == 1 | Schizophrenia == 1 | Psychosis == 1 | Personality_disorder == 1 | Phobia == 1 | Panic_attacks == 1 | OCD == 1 | BIP_Mania == 1 | Depression == 1 | BED == 1 | Autism == 1 | GAD == 1 | Agoraphobia == 1 | ADHD == 1 | Prefer_not_to_answer == 1] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_mqh[is.na(Psydx_mqh) ] <- 0) 
genotypes_qc_phenotypes$Psydx_mqh <- as.factor(genotypes_qc_phenotypes$Psydx_mqh)
summary(genotypes_qc_phenotypes$Psydx_mqh)
# 0      1
# 345307  40435
### identify Psydx_exAN_mqh cases
genotypes_qc_phenotypes["Psydx_exAN_mqh"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exAN_mqh[Anorexia_nervosa == 0 & (Bulimia_nervosa == 1 | Social_anxiety == 1 | Schizophrenia == 1 | Psychosis == 1 | Personality_disorder == 1 | Phobia == 1 | Panic_attacks == 1 | OCD == 1 | BIP_Mania == 1 | Depression == 1 | BED == 1 | Autism == 1 | GAD == 1 | Agoraphobia == 1 | ADHD == 1 | Prefer_not_to_answer == 1)] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exAN_mqh[is.na(Psydx_exAN_mqh) ] <- 0) 
genotypes_qc_phenotypes$Psydx_exAN_mqh <- as.factor(genotypes_qc_phenotypes$Psydx_exAN_mqh)
summary(genotypes_qc_phenotypes$Psydx_exAN_mqh)
# 0      1
# 346039  39703
### identify Psydx_exBN_mqh cases
genotypes_qc_phenotypes["Psydx_exBN_mqh"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exBN_mqh[Bulimia_nervosa == 0 & (Anorexia_nervosa == 1 | Social_anxiety == 1 | Schizophrenia == 1 | Psychosis == 1 | Personality_disorder == 1 | Phobia == 1 | Panic_attacks == 1 | OCD == 1 | BIP_Mania == 1 | Depression == 1 | BED == 1 | Autism == 1 | GAD == 1 | Agoraphobia == 1 | ADHD == 1 | Prefer_not_to_answer == 1)] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exBN_mqh[is.na(Psydx_exBN_mqh) ] <- 0) 
genotypes_qc_phenotypes$Psydx_exBN_mqh <- as.factor(genotypes_qc_phenotypes$Psydx_exBN_mqh)
summary(genotypes_qc_phenotypes$Psydx_exBN_mqh)
# 0      1
# 345716  40026
### identify Psydx_exBED_mqh cases
genotypes_qc_phenotypes["Psydx_exBED_mqh"] <- NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exBED_mqh[BED == 0 & (Anorexia_nervosa == 1 | Social_anxiety == 1 | Schizophrenia == 1 | Psychosis == 1 | Personality_disorder == 1 | Phobia == 1 | Panic_attacks == 1 | OCD == 1 | BIP_Mania == 1 | Depression == 1 | Bulimia_nervosa == 1 | Autism == 1 | GAD == 1 | Agoraphobia == 1 | ADHD == 1 | Prefer_not_to_answer == 1)] <- 1) 
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Psydx_exBED_mqh[is.na(Psydx_exBED_mqh) ] <- 0) 
genotypes_qc_phenotypes$Psydx_exBED_mqh <- as.factor(genotypes_qc_phenotypes$Psydx_exBED_mqh)
summary(genotypes_qc_phenotypes$Psydx_exBED_mqh)
# 0      1
# 345868  39874


### delete MHQ columns
genotypes_qc_phenotypes$MHQ1 <- NULL
genotypes_qc_phenotypes$MHQ2 <- NULL
genotypes_qc_phenotypes$MHQ3 <- NULL
genotypes_qc_phenotypes$MHQ4 <- NULL
genotypes_qc_phenotypes$MHQ5 <- NULL
genotypes_qc_phenotypes$MHQ6 <- NULL
genotypes_qc_phenotypes$MHQ7 <- NULL
genotypes_qc_phenotypes$MHQ8 <- NULL
genotypes_qc_phenotypes$MHQ9 <- NULL
genotypes_qc_phenotypes$MHQ10 <- NULL
genotypes_qc_phenotypes$MHQ11 <- NULL
genotypes_qc_phenotypes$MHQ12 <- NULL
genotypes_qc_phenotypes$MHQ13 <- NULL
genotypes_qc_phenotypes$MHQ14 <- NULL
genotypes_qc_phenotypes$MHQ15 <- NULL
genotypes_qc_phenotypes$MHQ16 <- NULL


##### Menopause & Pregnancy #####
### recoding of variables
### create empty column
genotypes_qc_phenotypes["Menopause_new"] <- NA
### code Menopause (Gender = 1 = male)
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 1 & is.na(Menopause)] <- 0) #### male & NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & is.na(Menopause)] <- 1) #### female & NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & Menopause == 1] <- 2) #### female & yes
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & Menopause == 2] <- 3) #### female & hysterectomy
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & Menopause == 3] <- 4) #### female & not sure
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & Menopause == -3] <- 5) #### female & prefer not to answer
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_new[Gender == 0 & Menopause == 0] <- 6) #### female & no
genotypes_qc_phenotypes$Menopause_new <- as.factor(genotypes_qc_phenotypes$Menopause_new)
summary(genotypes_qc_phenotypes$Menopause_new)
#      0      1      2      3      4      5      6   NA's
# 177552    128 127330  23826   8896    183  47825      2


#### Recode Menopause to binary
### create empty column
genotypes_qc_phenotypes["Menopause_bin"] <- NA
### code Menopause (Gender = 1 = male)
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 0] <- 0) #### male & NA
#genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 1] <- NA) #### female & NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 2] <- 1) #### female & yes
#genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 3] <- NA) #### female & not sure/hysterectomy
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 4] <- 0) #### female & not sure
#genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 5] <- NA) #### female & prefer not to answer
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Menopause_bin[Menopause_new == 6] <- 0) #### female & no
genotypes_qc_phenotypes$Menopause_bin <- as.factor(genotypes_qc_phenotypes$Menopause_bin)
summary(genotypes_qc_phenotypes$Menopause_bin)
#     0      1   NA's
# 234273 127330  24139


#### Recode pregnant 
### create empty column
genotypes_qc_phenotypes["Pregnant_new"] <- NA
### code Menopause (Gender = 1 = male)
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Pregnant_new[Gender == 1 & is.na(Pregnant)] <- 0) #### male & NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Pregnant_new[Gender == 0 & is.na(Pregnant)] <- 1) #### female & NA
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Pregnant_new[Gender == 0 & Pregnant == 0] <- 2) #### female & no
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Pregnant_new[Gender == 0 & Pregnant == 1] <- 3) #### female & yes
genotypes_qc_phenotypes <- within(genotypes_qc_phenotypes, Pregnant_new[Gender == 0 & Pregnant == 2] <- 4) #### female & unsure
genotypes_qc_phenotypes$Pregnant_new <- as.factor(genotypes_qc_phenotypes$Pregnant_new)
summary(genotypes_qc_phenotypes$Pregnant_new)
#     0      1      2      3      4   NA's
# 177552    209 207720    105    154      2


#### Dummy coding of alcohol, tobacco ########
### code dummy variables for Alcohol_frequency
for(level in unique(genotypes_qc_phenotypes$Alcohol_frequency)){
  genotypes_qc_phenotypes[paste("Alcohol_frequency", level, sep = "_")] <- ifelse(genotypes_qc_phenotypes$Alcohol_frequency == level, 1, 0)
}
### code dummy variables for Current_tobacco
for(level in unique(genotypes_qc_phenotypes$Current_tobacco)){
  genotypes_qc_phenotypes[paste("Current_tobacco", level, sep = "_")] <- ifelse(genotypes_qc_phenotypes$Current_tobacco == level, 1, 0)
}
### delte NA columns of alcohol and tobacco
genotypes_qc_phenotypes$Alcohol_frequency_NA <- NULL
genotypes_qc_phenotypes$Current_tobacco_NA <- NULL


##### Import categories of Drugs, Diseases, and Cancer register ####
### read in binary file prepared with Helena's scripts
drugs_diseases_cancer <- read.table(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Phenotypes/Chris_July_2017/medication_diagnoses_cancer.txt", header = TRUE, as.is = TRUE)
### delete additional ID column
drugs_diseases_cancer$IDS <- NULL
drugs_diseases_cancer$IDS.1 <- NULL
### rename columns with the same name but different meaning
drugs_diseases_cancer <- rename(drugs_diseases_cancer, has_cancer_register = cancer_register)
drugs_diseases_cancer <- rename(drugs_diseases_cancer, cancer_register_entry = cancer_register.1)
drugs_diseases_cancer <- rename(drugs_diseases_cancer, IID = id)
### vector with columns which need to be recoded as factors
cols <- c("has_disease", "has_drug", "has_cancer_register", "IID", 
          "Corticoids", "Diabetes", "Diuretics", "Gonadotropins", 
          "Growth_Hormone", "HIV", "HRT_Contraceptives", "Osteoporosis", 
          "Testosterone", "Thyroid", "Tuberculosis_Leprosy", "Antidepressants", 
          "Antineoplastics", "Antipsychotics", 
          "cancer_hospital_main", "cancer_hospital_secondary", "cancer_register_entry", 
          "connective_tissue_main", "connective_tissue_secondary", "diabetes_main", 
          "diabetes_secondary", "endocrine_main", "endocrine_secondary", 
          "glucose_main", "glucose_secondary", "hiv_main", "hiv_secondary", 
          "IBD_main", "IBD_secondary", "IBS_main", "IBS_secondary", 
          "liver_main", "liver_secondary", "mental_disorders_main", 
          "mental_disorders_secondary", "metabolic_main", "metabolic_secondary", 
          "muscles_main", "muscles_secondary", "pancreatitis_main", 
          "pancreatitis_secondary", "thyroid_main", "thyroid_secondary", 
          "tuberculosis_main", "tuberculosis_secondary")
### recode as factors
drugs_diseases_cancer[cols] <- lapply(drugs_diseases_cancer[cols], factor)
### sanity check
head(drugs_diseases_cancer)
# has_disease has_drug has_cancer_register     IID Corticoids Diabetes
# 1           1        1                   0 1000015          0        1
# 2           1        1                   0 1000027          0        1
dim(drugs_diseases_cancer)
# 502619     49
### write summary
summary_drugs_diseases_cancer <- summary(drugs_diseases_cancer)
### export summary to CSV file for number of exclusion criteria
write.csv(summary_drugs_diseases_cancer, file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Phenotypes/Chris_July_2017/diagnoses_cancer_medication_frequencies.csv")
### merge IDs, phenotypes, drugs, diseases, and cancer
genotypes_qc_phenotypes_drugs_diseases_cancer <- merge(genotypes_qc_phenotypes, drugs_diseases_cancer, all = FALSE, sort = FALSE)
### sanity check
dim(genotypes_qc_phenotypes_drugs_diseases_cancer)
# 385742    103
head(genotypes_qc_phenotypes_drugs_diseases_cancer)
# IID Passed_QC_both Gender Age Menopause      SES Centre Current_tobacco
# 1 4439466              2      0  46         3 -2.61299  11011               0
# 2 3643257              2      0  52         1 -5.86031  11011               0
summary(genotypes_qc_phenotypes_drugs_diseases_cancer)
# IID         Passed_QC_both Gender          Age        Menopause
# 1000015:     1   1:177554       0:208188   Min.   :38.00   -3  :   185
# 1000039:     1   2:208188       1:177554   1st Qu.:50.00   0   : 47825


#### Summary statistics all (includes hysterectomy, incomplete cases; before any exclusion criteria) ####
### vectors with columns which need to be factors
cols_factors_all <- c("Alcohol_frequency_2", "Alcohol_frequency_1", "Alcohol_frequency_6", 
                  "Alcohol_frequency_5", "Alcohol_frequency_3", "Alcohol_frequency_4", 
                  "Alcohol_frequency_-3", "Current_tobacco_0", "Current_tobacco_1", 
                  "Current_tobacco_2", "Current_tobacco_-3")
### change columns to factors
genotypes_qc_phenotypes_drugs_diseases_cancer[cols_factors_all] <- lapply(genotypes_qc_phenotypes_drugs_diseases_cancer[cols_factors_all], factor)
### sanity check show classes
sapply(genotypes_qc_phenotypes_drugs_diseases_cancer, class)
# IID              Passed_QC_both
# "factor"                    "factor"


### all European participants (moving dataframe)
genotypes_qc_phenotypes_all <- genotypes_qc_phenotypes_drugs_diseases_cancer
dim(genotypes_qc_phenotypes_all)
# 385742    103

#### Female and male subset of all European participants ####
### Female
genotypes_qc_phenotypes_all_female <- subset(genotypes_qc_phenotypes_all, Gender == 0)
dim(genotypes_qc_phenotypes_all_female)
# 208188   103
### Male
genotypes_qc_phenotypes_all_male <- subset(genotypes_qc_phenotypes_all, Gender == 1)
dim(genotypes_qc_phenotypes_all_male)
# 177554   103


#### Descriptives categorical: factors and continuous: fBasics for all European participants ####
### write categorical 
sum_genotypes_qc_phenotypes_all <- summary(genotypes_qc_phenotypes_all)
sum_genotypes_qc_phenotypes_all_female <- summary(genotypes_qc_phenotypes_all_female)
sum_genotypes_qc_phenotypes_all_male <- summary(genotypes_qc_phenotypes_all_male)
### export summary statistics for all European participants without exclusion
### both
write.csv(sum_genotypes_qc_phenotypes_all, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cat_european_all_both.csv", quote = F)
### female
write.csv(sum_genotypes_qc_phenotypes_all_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cat_european_all_female.csv", quote = F)
### male
write.csv(sum_genotypes_qc_phenotypes_all_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cat_european_all_male.csv", quote = F)


### identifying numeric columns
numeric_columns_all <- sapply(genotypes_qc_phenotypes_all, is.numeric)
### write phenotypic summary stats for continuous variables
### both
summary_statistics_all <- basicStats(genotypes_qc_phenotypes_all[, numeric_columns_all])
write.csv(summary_statistics_all, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cont_european_all.csv", quote = F)
### female
summary_statistics_all_female <- basicStats(genotypes_qc_phenotypes_all_female[, numeric_columns_all])
write.csv(summary_statistics_all_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cont_european_all_female.csv", quote = F)
### male
summary_statistics_all_male <- basicStats(genotypes_qc_phenotypes_all_male[, numeric_columns_all])
write.csv(summary_statistics_all_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all/phenotypic_stats_cont_european_all_male.csv", quote = F)

#### Export phenotypes all European ####
### export phenotype data of all European participants (includes hysterectomy, incomplete cases; before any exclusion criteria)
write.table(genotypes_qc_phenotypes_all, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/all/phenotypes_european_all.txt", sep = ""), quote = F, col.names = T, row.names = F)


#### Add genetic covariates ####
#### Batch and array type ####
batch_array <- fread(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Genotypes/Chris_July_2017/2754_Batch_Array.txt", header = FALSE)
### colnames
colnames(batch_array) <- c("IID", "Array", "Batch")
### sanity check
dim(batch_array)
# 488377      3
### merge IDs, phenotypes, drug, diseases, cancer, and batch and array
genotypes_qc_phenotypes_complete_batch_array <- merge(genotypes_qc_phenotypes_all, batch_array, all = FALSE, sort = FALSE)
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array)
# 385742    105


#### Principal components ####
### import calculated pcas
pcas <- fread(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Genotypes/Chris_July_2017/qc_set/pruned/pcs_pcas.txt", header = TRUE)
dim(pcas)
# 385753     17
### select 15 pcas
pcas_reduced <- pcas[,2:17]
dim(pcas_reduced)
# 385753     16
head(pcas_reduced)
# IID           PC1          PC2           PC3          PC4          PC5
# 1: 1993198 -2.784401e-03  0.010575510 -0.0025181620  0.004471868  0.003050466
# 2: 4439466 -5.158666e-03  0.013464870 -0.0044013210 -0.002934733  0.006521125
### merge IDs, phenotypes, drug, diseases, cancer, batch, array, and pcas
genotypes_qc_phenotypes_complete_batch_array_pcas <- merge(genotypes_qc_phenotypes_complete_batch_array, pcas_reduced, all = FALSE, sort = FALSE)
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array_pcas)
# 385742    120 (different of 11 individuals because the decided to leave the UKBB study; at least the genetic part)


#### Dummy coding for assessment centre and batch; and binary UKBB & UKBL #####
### check for NAs in centre
summary(genotypes_qc_phenotypes_complete_batch_array_pcas$Centre)
# 10003 11001 11002 11003 11004 11005 11006 11007 11008 11009 11010 11011 11012
# 355 10784 11661 14190 15177 13850 14793 24569 22706 27975 34673 34202  9145
# 11013 11014 11016 11017 11018 11020 11021 11022 11023
# 26724 23491 25308 16319 19859 19225 18413  1800   523
### code dummy variables for centre
for(level in unique(genotypes_qc_phenotypes_complete_batch_array_pcas$Centre)){
  genotypes_qc_phenotypes_complete_batch_array_pcas[paste("Centre", level, sep = "_")] <- ifelse(genotypes_qc_phenotypes_complete_batch_array_pcas$Centre == level, 1, 0)
}
### check for NAs in batch
summary(is.na(genotypes_qc_phenotypes_complete_batch_array_pcas$Batch))
# Mode   FALSE
# logical  385742
### code dummy variables for batch
for(level in unique(genotypes_qc_phenotypes_complete_batch_array_pcas$Batch)){
  genotypes_qc_phenotypes_complete_batch_array_pcas[paste("Batch", level, sep = "_")] <- ifelse(genotypes_qc_phenotypes_complete_batch_array_pcas$Batch == level, 1, 0)
}


### create empty column for binary chip
genotypes_qc_phenotypes_complete_batch_array_pcas["Array_bin"] <- NA
### recode arrys to 0 and 1
genotypes_qc_phenotypes_complete_batch_array_pcas <- within(genotypes_qc_phenotypes_complete_batch_array_pcas, Array_bin[Array == "UKBB"] <- 0) #### UKBB
genotypes_qc_phenotypes_complete_batch_array_pcas <- within(genotypes_qc_phenotypes_complete_batch_array_pcas, Array_bin[Array == "UKBL"] <- 1) #### UKBL
### make binary array column to factor
genotypes_qc_phenotypes_complete_batch_array_pcas$Array_bin <- as.factor(genotypes_qc_phenotypes_complete_batch_array_pcas$Array_bin)
### sanity check of genotyping chip type
summary(genotypes_qc_phenotypes_complete_batch_array_pcas$Array_bin)
#   0      1
# 344085  41657


#### Add self-reported illness or cancer diagnoses ####
### import awk'ed self-report illness and cancer columns from larger UKBB file
cancer_illness_0_1_2 <- fread(input = "/mnt/lustre/groups/ukbiobank/KCL_Data/Phenotypes/Chris_July_2017/selfreport/cancer_illness_0_1_2.txt", header = TRUE)
# Read 502618 rows and 77 (of 77) columns from 0.112 GB file in 00:00:03
### add column names
colnames(cancer_illness_0_1_2) <- c("IID", "spcancer0_0", "spcancer0_1", "spcancer0_2", "spcancer0_3", "spcancer0_4", "spcancer0_5", "spcancer1_0", 
                                    "spcancer1_1", "spcancer1_2", "spcancer1_3", "spcancer2_0", "spcancer2_1", "spcancer2_2", "spcancer2_3", "spillness0_0", 
                                    "spillness0_1",  "spillness0_2",  "spillness0_3",  "spillness0_4",  "spillness0_5",  "spillness0_6",  "spillness0_7",  
                                    "spillness0_8",  "spillness0_9",  "spillness0_10", "spillness0_11", "spillness0_12", "spillness0_13", "spillness0_14", 
                                    "spillness0_15", "spillness0_16", "spillness0_17", "spillness0_18", "spillness0_19", "spillness0_20", "spillness0_21", 
                                    "spillness0_22", "spillness0_23", "spillness0_24", "spillness0_25", "spillness0_26", "spillness0_27", "spillness0_28", 
                                    "spillness1_0",  "spillness1_1",  "spillness1_2",  "spillness1_3",  "spillness1_4",  "spillness1_5",  "spillness1_6",  
                                    "spillness1_7",  "spillness1_8",  "spillness1_9",  "spillness1_10", "spillness1_11", "spillness1_12", "spillness1_13", 
                                    "spillness1_14", "spillness1_15", "spillness2_0",  "spillness2_1",  "spillness2_2",  "spillness2_3",  "spillness2_4",  
                                    "spillness2_5",  "spillness2_6",  "spillness2_7",  "spillness2_8",  "spillness2_9",  "spillness2_10", "spillness2_11", 
                                    "spillness2_12", "spillness2_13", "spillness2_14", "spillness2_15", "spillness2_16")
### recode NAs as 0
cancer_illness_0_1_2[is.na(cancer_illness_0_1_2)] <- 0
### sanity check
summary(cancer_illness_0_1_2)
# IID           spcancer0_0       spcancer0_1        spcancer0_2
# Min.   :1000015   Min.   :    0.0   Min.   :    0.00   Min.   :    0.00
# 1st Qu.:2256563   1st Qu.:    0.0   1st Qu.:    0.00   1st Qu.:    0.00
### merge IDs, phenotypes, drug, diseases, cancer, batch, array, pcas, self-reported cancer & illnesses
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport <- merge(genotypes_qc_phenotypes_complete_batch_array_pcas, cancer_illness_0_1_2)
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport)
# 385742    325
### change from data.table into data.frame
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport <- as.data.frame(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport)
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport)
# 385742    325

### code last columns as factors
cols_factors_2 <- c("IID", "Passed_QC_both", "Gender", "Menopause", "Centre", "Current_tobacco", "Alcohol_frequency", "Pregnant", "MHQ_help", 
                    "has_disease", "has_drug", "has_cancer_register", "Alcohol_frequency_2", "Alcohol_frequency_1", "Alcohol_frequency_6", 
                    "Alcohol_frequency_5", "Alcohol_frequency_3", "Alcohol_frequency_4", "Alcohol_frequency_-3", "Current_tobacco_0", "Current_tobacco_1", 
                    "Current_tobacco_2", "Current_tobacco_-3", 
                    "Anorexia_nervosa", "Bulimia_nervosa", "Social_anxiety", "Schizophrenia", "Psychosis", "Personality_disorder", "Phobia", "Panic_attacks", 
                    "OCD", "BIP_Mania", "Depression", "BED", "Autism", "GAD", "Agoraphobia", "ADHD", "Prefer_not_to_answer", "Psydx_mqh","Psydx_exAN_mqh", 
                    "Psydx_exBN_mqh", "Psydx_exBED_mqh", "Menopause_new", "Menopause_bin", "Pregnant_new", 
                    "Corticoids", "Diabetes", "Diuretics", "Gonadotropins", "Growth_Hormone", "HIV", "HRT_Contraceptives", "Osteoporosis", "Testosterone", 
                    "Thyroid", "Tuberculosis_Leprosy", "Antidepressants", "Antineoplastics", "Antipsychotics", 
                    "cancer_hospital_main", "cancer_hospital_secondary", "cancer_register_entry", "connective_tissue_main", "connective_tissue_secondary", 
                    "diabetes_main", "diabetes_secondary", "endocrine_main", "endocrine_secondary", "glucose_main", "glucose_secondary", "hiv_main", 
                    "hiv_secondary", "IBD_main", "IBD_secondary", "IBS_main", "IBS_secondary", "liver_main", "liver_secondary", "mental_disorders_main", 
                    "mental_disorders_secondary", "metabolic_main", "metabolic_secondary", "muscles_main", "muscles_secondary", "pancreatitis_main", 
                    "pancreatitis_secondary", "thyroid_main", "thyroid_secondary", "tuberculosis_main", "tuberculosis_secondary", 
                    "Array", "Batch", "Centre_11011", "Centre_11009", "Centre_11021", "Centre_11016", "Centre_11014", "Centre_11010", "Centre_11017", 
                    "Centre_11013","Centre_11004", "Centre_11002", "Centre_11018", "Centre_11022", "Centre_11006", "Centre_11001", "Centre_11008", 
                    "Centre_11020", "Centre_11007", "Centre_11003", "Centre_11012", "Centre_11005", "Centre_10003", "Centre_11023", "Batch_Batch_b001", 
                    "Batch_Batch_b002", "Batch_Batch_b003", "Batch_Batch_b004", "Batch_Batch_b005", "Batch_Batch_b006", "Batch_Batch_b007", 
                    "Batch_Batch_b008", "Batch_Batch_b009", "Batch_Batch_b010", "Batch_Batch_b011", "Batch_Batch_b012", "Batch_Batch_b013", 
                    "Batch_Batch_b014", "Batch_Batch_b015", "Batch_Batch_b016", "Batch_Batch_b017", "Batch_Batch_b018", "Batch_Batch_b019", 
                    "Batch_Batch_b020", "Batch_Batch_b021", "Batch_Batch_b022", "Batch_Batch_b023", "Batch_Batch_b024", "Batch_Batch_b025", 
                    "Batch_Batch_b026", "Batch_Batch_b027", "Batch_Batch_b028", "Batch_Batch_b029", "Batch_Batch_b030", "Batch_Batch_b031", 
                    "Batch_Batch_b032", "Batch_Batch_b033", "Batch_Batch_b034", "Batch_Batch_b035", "Batch_Batch_b036", "Batch_Batch_b037", 
                    "Batch_Batch_b038", "Batch_Batch_b039", "Batch_Batch_b040", "Batch_Batch_b041", "Batch_Batch_b042", "Batch_Batch_b043", 
                    "Batch_Batch_b044", "Batch_Batch_b045", "Batch_Batch_b046", "Batch_Batch_b047", "Batch_Batch_b048", "Batch_Batch_b049", 
                    "Batch_Batch_b050", "Batch_Batch_b051", "Batch_Batch_b052", "Batch_Batch_b053", "Batch_Batch_b054", "Batch_Batch_b055", 
                    "Batch_Batch_b056", "Batch_Batch_b057", "Batch_Batch_b058", "Batch_Batch_b059", "Batch_Batch_b060", "Batch_Batch_b061", 
                    "Batch_Batch_b062", "Batch_Batch_b063", "Batch_Batch_b064", "Batch_Batch_b065", "Batch_Batch_b066", "Batch_Batch_b067", 
                    "Batch_Batch_b068", "Batch_Batch_b069", "Batch_Batch_b070", "Batch_Batch_b071", "Batch_Batch_b072", "Batch_Batch_b073", 
                    "Batch_Batch_b074", "Batch_Batch_b075", "Batch_Batch_b076", "Batch_Batch_b077", "Batch_Batch_b078", "Batch_Batch_b079", 
                    "Batch_Batch_b080", "Batch_Batch_b081", "Batch_Batch_b082", "Batch_Batch_b083", "Batch_Batch_b084", "Batch_Batch_b085", 
                    "Batch_Batch_b086", "Batch_Batch_b087", "Batch_Batch_b088", "Batch_Batch_b089", "Batch_Batch_b090", "Batch_Batch_b091", 
                    "Batch_Batch_b092", "Batch_Batch_b093", "Batch_Batch_b094", "Batch_Batch_b095", "Batch_UKBiLEVEAX_b1", "Batch_UKBiLEVEAX_b2", 
                    "Batch_UKBiLEVEAX_b3", "Batch_UKBiLEVEAX_b4", "Batch_UKBiLEVEAX_b5", "Batch_UKBiLEVEAX_b6", "Batch_UKBiLEVEAX_b7", 
                    "Batch_UKBiLEVEAX_b8", "Batch_UKBiLEVEAX_b9", "Batch_UKBiLEVEAX_b10", "Batch_UKBiLEVEAX_b11", "spcancer0_0", "spcancer0_1", 
                    "spcancer0_2", "spcancer0_3", "spcancer0_4", "spcancer0_5", "spcancer1_0", "spcancer1_1", "spcancer1_2", "spcancer1_3", 
                    "spcancer2_0", "spcancer2_1", "spcancer2_2", "spcancer2_3", "spillness0_0",  "spillness0_1",  "spillness0_2",  "spillness0_3",  
                    "spillness0_4",  "spillness0_5",  "spillness0_6",  "spillness0_7",  "spillness0_8",  "spillness0_9",  "spillness0_10", 
                    "spillness0_11", "spillness0_12", "spillness0_13", "spillness0_14", "spillness0_15", "spillness0_16", "spillness0_17", 
                    "spillness0_18", "spillness0_19", "spillness0_20", "spillness0_21", "spillness0_22", "spillness0_23", "spillness0_24", 
                    "spillness0_25", "spillness0_26", "spillness0_27", "spillness0_28", "spillness1_0",  "spillness1_1",  "spillness1_2",  
                    "spillness1_3",  "spillness1_4",  "spillness1_5",  "spillness1_6",  "spillness1_7",  "spillness1_8",  "spillness1_9",  
                    "spillness1_10", "spillness1_11", "spillness1_12", "spillness1_13", "spillness1_14", "spillness1_15", "spillness2_0",  
                    "spillness2_1",  "spillness2_2",  "spillness2_3",  "spillness2_4",  "spillness2_5",  "spillness2_6",  "spillness2_7",  
                    "spillness2_8",  "spillness2_9",  "spillness2_10", "spillness2_11", "spillness2_12", "spillness2_13", "spillness2_14", 
                    "spillness2_15", "spillness2_16")
### change columns to factors
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport[cols_factors_2] <- lapply(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport[cols_factors_2], factor)
### sanity check
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport)
# IID         Passed_QC_both Gender          Age        Menopause
# 1000015:     1   1:177554       0:208188   Min.   :38.00   -3  :   185
# 1000039:     1   2:208188       1:177554   1st Qu.:50.00   0   : 47825
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport)
# 385742  325


#### Descriptives of all European including genetic data and self reports ####
### all European participants including genetic covariates and self-report (moving dataframe)
all_genetic <- genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport
dim(all_genetic)
# 385742    325

#### Female and male subset of all European participants ####
### Female
all_genetic_female <- subset(all_genetic, Gender == 0)
dim(all_genetic_female)
# 208188   325
### Male
all_genetic_male <- subset(all_genetic, Gender == 1)
dim(all_genetic_male)
# 177554   325

#### Descriptives categorical: factors and continuous: fBasics for all European participants including genetic and self-report ####
### write categorical 
sum_all_genetic <- summary(all_genetic)
sum_all_genetic_female <- summary(all_genetic_female)
sum_all_genetic_male <- summary(all_genetic_male)
### export summary statistics for all European participants without exclusion
### both
write.csv(sum_all_genetic, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cat_european_all_genetic.csv", quote = F)
### female
write.csv(sum_all_genetic_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cat_european_all_genetic_female.csv", quote = F)
### male
write.csv(sum_all_genetic_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cat_european_all_genetic_male.csv", quote = F)


### identifying numeric columns
numeric_columns_all <- sapply(all_genetic, is.numeric)
### write phenotypic summary stats for continuous variables
### both
summary_statistics_all_genetic <- basicStats(all_genetic[, numeric_columns_all])
write.csv(summary_statistics_all_genetic, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cont_european_all_genetic_both.csv", quote = F)
### female
summary_statistics_all_genetic_female <- basicStats(all_genetic_female[, numeric_columns_all])
write.csv(summary_statistics_all_genetic_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cont_european_all_genetic_female.csv", quote = F)
### male
summary_statistics_all_genetic_male <- basicStats(all_genetic_male[, numeric_columns_all])
write.csv(summary_statistics_all_genetic_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/all_genetic/phenotypic_stats_cont_european_all_genetic_male.csv", quote = F)


#### Export phenotypes all European genetic ####
### export phenotype data of all European participants (includes hysterectomy, incomplete cases; before any exclusion criteria)
write.table(all_genetic, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/all/phenotypes_european_all_genetic.txt", sep = ""), quote = F, col.names = T, row.names = F)


#### Preparation for exclusion ####
### rename columns with minus sign in column name
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport <- rename(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport, Alcohol_frequency__3 = "Alcohol_frequency_-3")
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport <- rename(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport, Current_tobacco__3 = "Current_tobacco_-3")
### delete columns with large numbers of NA for complete cases selection
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$Menopause <- NULL
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$Pregnant <- NULL
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$MHQ_help <- NULL
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$Passed_QC_both <- NULL
### check classes
sapply(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport, class)
# IID                      Gender
# "factor"                    "factor"


######################################################
#### EXCLUSION BODY COMPOSITION  COMPLETE (300K) #####
######################################################

#### Subset without hysterectomy and pregnancy ####
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause <- subset(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport, Menopause_new == 0 | Menopause_new == 2 | Menopause_new == 4 | Menopause_new == 6)
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause)
# 361603    325
### prior to subsetting
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$Menopause_new)
#0          1        2      3      4      5      6      NA's
#177552    128  127330  23826   8896    183  47825      2
### Menopause after subsetting
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause$Menopause_new)
# 0           1      2        3        4         5      6
# 177552      0     127330     0     8896      0     47825
### Lable explanation menopause
# 0) #### male & NA
# 1) #### female & NA
# 2) #### female & yes
# 3) #### female & hysterectomy
# 4) #### female & not sure
# 5) #### female & prefer not to answer
# 6) #### female & no


#### Subset without pregnant women ####
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy <- subset(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause, Pregnant_new == 0 | Pregnant_new == 2)
### Prior to subsetting of hysterectomy and menopause
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport$Pregnant_new)
#0          1      2      3      4   NA's
#177552    209 207720    105    154      2
### Prior to subsetting of pregnancy
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause$Pregnant_new)
#     0      1      2      3      4
#177552    174 183623    104    150
### After subsetting of pregnancy
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy$Pregnant_new)
#0           1      2      3      4
#177552      0 183623      0      0
### Label explanation pregnancy
# 0) #### male & NA
# 1) #### female & NA
# 2) #### female & no
# 3) #### female & yes
# 4) #### female & unsure

### Double check: there should be no NAs anymore in the binary Menopause variable
summary(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy$Menopause_bin)
# 0      1
# 233987 127188
### Label explanation
# 0) #### male & NA
# NA) #### female & NA
# 1) #### female & yes
# NA) #### female & not sure/hysterectomy
# 0) #### female & not sure
# NA) #### female & prefer not to answer
# 0) #### female & no
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy)
# 361175 321

#### complete cases without hysterectomy and pregnancy including diagnoses, medication, selfreport, and genetic variables
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases <- genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy[complete.cases(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy),]
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases)
# 353972    321


#### Phenotype file with only body composition and phenotypic covariates; no genetic ####
### Body composition variabels
bc_variables <- c("IID", "Gender", "Age", "SES", "Weight", "BMI", "FFM", "FM", 
                  "BFPC", "Height", "WC", "HC", "WHR", "has_disease", "has_drug", 
                  "has_cancer_register", "Alcohol_frequency_2", "Alcohol_frequency_1", 
                  "Alcohol_frequency_6", "Alcohol_frequency_5", "Alcohol_frequency_3", 
                  "Alcohol_frequency_4", "Alcohol_frequency__3", "Current_tobacco_0", 
                  "Current_tobacco_1", "Current_tobacco_2", "Current_tobacco__3", 
                  "Menopause_new", "Menopause_bin")
### Subset
body_composition_participants <- genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases[bc_variables]
### Sanity check
dim(body_composition_participants)
# 353972     29
### export file
write.table(body_composition_participants, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/complete/phenotypes_european_complete_bc_only.txt", quote = F, col.names = T, row.names = F)

#### Descriptives complete (300K) ####

### move
complete <- genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases
##### Female and Male subset ########
### Female
complete_female <- subset(complete, Gender == 0)
dim(complete_female)
# 180765   321
### Male
complete_male <- subset(complete, Gender == 1)
dim(complete_male)
# 173207   321


### write categorical 
sum_complete <- summary(complete)
sum_complete_female <- summary(complete_female)
sum_complete_male <- summary(complete_male)
### export summary statistics for all European participants without exclusion
### both
write.csv(sum_complete, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cat_european_complete_both.csv", quote = F)
### female
write.csv(sum_complete_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cat_european_complete_female.csv", quote = F)
### male
write.csv(sum_complete_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cat_european_complete_male.csv", quote = F)


### identify numeric columns
numeric_columns_complete <- sapply(complete, is.numeric)
### Write continuous summary statistics
##sex-combined
summary_statistics_complete <- basicStats(complete[, numeric_columns_complete])
write.csv(summary_statistics_complete, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cont_european_complete_both.csv", quote = F)
##female
summary_statistics_complete_female <- basicStats(complete_female[, numeric_columns_complete])
write.csv(summary_statistics_complete_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cont_european_complete_female.csv", quote = F)
##male
summary_statistics_complete_male <- basicStats(complete_male[, numeric_columns_complete])
write.csv(summary_statistics_complete_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/complete/phenotypic_stats_cont_european_complete_male.csv", quote = F)

##### export after exclusion criteria
write.table(complete, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/complete/phenotypes_european_complete.txt", sep = ""), quote = F, col.names = T, row.names = F)


######################################################
#### EXCLUSION BODY COMPOSITION  HEALTHY (150K) #####
######################################################

#### Exclusion self-reported illness or cancer ####
### vector with codes for self-reported cancer
cancer_criteria = c(1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 
                    1012, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022, 1023, 1024, 
                    1025, 1026, 1027, 1028, 1031, 1032, 1033, 1034, 1035, 1036, 1037,
                    1038, 1039, 1040, 1041, 1042, 1043, 1044, 1045, 1046, 1047, 1048,
                    1050, 1051, 1052, 1053, 1055, 1056, 1058, 1059, 1060, 1061, 1062,
                    1063, 1064, 1065, 1066, 1067, 1068, 1070, 1071, 1073, 1074, 1075,
                    1076, 1077, 1078, 1079, 1080, 1081, 1082, 1084, 1085, 1086, 1087, 1088)
### logic to exclude those cancers
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer <- subset(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases, 
                                             !(spcancer0_0 %in% cancer_criteria) & !(spcancer0_1 %in% cancer_criteria) & !(spcancer0_2 %in% cancer_criteria) & 
                                               !(spcancer0_3 %in% cancer_criteria) & !(spcancer0_4 %in% cancer_criteria) & !(spcancer0_5 %in% cancer_criteria) & 
                                               !(spcancer1_0 %in% cancer_criteria) & !(spcancer1_1 %in% cancer_criteria) & !(spcancer1_2 %in% cancer_criteria) & 
                                               !(spcancer1_3 %in% cancer_criteria) & !(spcancer2_0 %in% cancer_criteria) & !(spcancer2_1 %in% cancer_criteria) & 
                                               !(spcancer2_2 %in% cancer_criteria) & !(spcancer2_3 %in% cancer_criteria)
)
### sanity check
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer)
# 325672    321
### vector with codes for self-reported illnesses
illness_criteria = c(1136, 1154, 1155, 1156, 1157, 1158, 1164, 1165, 1192, 1193, 1194, 1220, 1222, 1223, 1224, 1225, 1226, 1228, 1229, 
                     1230, 1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1243, 1252, 1259, 1260, 1262, 1263, 1276, 1286, 1287, 1289, 
                     1290, 1291, 1293, 1297, 1308, 1309, 1310, 1313, 1322, 1350, 1373, 1376, 1377, 1378, 1379, 1380, 1381, 1382, 1383, 
                     1384, 1403, 1404, 1408, 1409, 1410, 1428, 1429, 1430, 1431, 1432, 1437, 1439, 1440, 1456, 1461, 1462, 1463, 1464, 
                     1468, 1469, 1470, 1477, 1480, 1481, 1519, 1520, 1521, 1522, 1531, 1556, 1579, 1580, 1604, 1607, 1608, 1609, 1611, 
                     1615, 1617, 1657, 1664, 1682)
### logic to exclude those ilnesses
genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer_illness <- subset(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer, 
                                                     !(spillness0_0 %in% illness_criteria) & !(spillness0_1 %in% illness_criteria) & !(spillness0_2 %in% illness_criteria) & 
                                                       !(spillness0_3 %in% illness_criteria) & !(spillness0_4 %in% illness_criteria) & !(spillness0_5 %in% illness_criteria) & 
                                                       !(spillness0_6 %in% illness_criteria) & !(spillness0_7 %in% illness_criteria) & !(spillness0_8 %in% illness_criteria) & 
                                                       !(spillness0_9 %in% illness_criteria) & !(spillness0_10 %in% illness_criteria) & !(spillness0_11 %in% illness_criteria) & 
                                                       !(spillness0_12 %in% illness_criteria) & !(spillness0_13 %in% illness_criteria) & !(spillness0_14 %in% illness_criteria) & 
                                                       !(spillness0_15 %in% illness_criteria) & !(spillness0_16 %in% illness_criteria) & !(spillness0_17 %in% illness_criteria) & 
                                                       !(spillness0_18 %in% illness_criteria) & !(spillness0_19 %in% illness_criteria) & !(spillness0_20 %in% illness_criteria) & 
                                                       !(spillness0_21 %in% illness_criteria) & !(spillness0_22 %in% illness_criteria) & !(spillness0_23 %in% illness_criteria) & 
                                                       !(spillness0_24 %in% illness_criteria) & !(spillness0_25 %in% illness_criteria) & !(spillness0_26 %in% illness_criteria) & 
                                                       !(spillness0_27 %in% illness_criteria) & !(spillness0_28 %in% illness_criteria) & !(spillness1_0 %in% illness_criteria) & 
                                                       !(spillness1_1 %in% illness_criteria) & !(spillness1_2 %in% illness_criteria) & !(spillness1_3 %in% illness_criteria) & 
                                                       !(spillness1_4 %in% illness_criteria) & !(spillness1_5 %in% illness_criteria) & !(spillness1_6 %in% illness_criteria) & 
                                                       !(spillness1_7 %in% illness_criteria) & !(spillness1_8 %in% illness_criteria) & !(spillness1_9 %in% illness_criteria) & 
                                                       !(spillness1_10 %in% illness_criteria) & !(spillness1_11 %in% illness_criteria) & !(spillness1_12 %in% illness_criteria) & 
                                                       !(spillness1_13 %in% illness_criteria) & !(spillness1_14 %in% illness_criteria) & !(spillness1_15 %in% illness_criteria) & 
                                                       !(spillness2_0 %in% illness_criteria) & !(spillness2_1 %in% illness_criteria) & !(spillness2_2 %in% illness_criteria) & 
                                                       !(spillness2_3 %in% illness_criteria) & !(spillness2_4 %in% illness_criteria) & !(spillness2_5 %in% illness_criteria) & 
                                                       !(spillness2_6 %in% illness_criteria) & !(spillness2_7 %in% illness_criteria) & !(spillness2_8 %in% illness_criteria) & 
                                                       !(spillness2_9 %in% illness_criteria) & !(spillness2_10 %in% illness_criteria) & !(spillness2_11 %in% illness_criteria) & 
                                                       !(spillness2_12 %in% illness_criteria) & !(spillness2_13 %in% illness_criteria) & !(spillness2_14 %in% illness_criteria) & 
                                                       !(spillness2_15 %in% illness_criteria) & !(spillness2_16 %in% illness_criteria)
)
dim(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer_illness)
# 246808    321

###### subset of healthy without medication, cancer, somatic disease influencing BC, psychiatric disorder, did not answer smoking or alcohol ####
healthy <- subset(genotypes_qc_phenotypes_complete_batch_array_pcas_selfreport_menopause_pregnancy_complete_cases_subset_cancer_illness, has_disease == 0 & has_drug == 0 & has_cancer_register == 0 & Alcohol_frequency__3 == 0 & Current_tobacco__3 == 0 & Psydx_mqh == 0)
summary(healthy)

dim(healthy)
# 155961    321

nrow(healthy)
# 191162 old without MHQ

## 173374 new excluding participants who endorsed a psychiatric disorder via MHQ

## 155961 new excluding, ICD, cancer register, self-report, MHQ

### Subset
body_composition_participants_healthy <- healthy[bc_variables]
### Sanity check
dim(body_composition_participants_healthy)
# 155961     29
### export file
write.table(body_composition_participants_healthy, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/healthy/phenotypes_european_healthy_bc_only.txt", quote = F, col.names = T, row.names = F)





##### Female and Male subset ########
### Female
healthy_female <- subset(healthy, Gender == 0)
dim(healthy_female)
# 70700   321
### Male
healthy_male <- subset(healthy, Gender == 1)
dim(healthy_male)
# 85261   321

### write categorical 
sum_healthy <- summary(healthy)
sum_healthy_female <- summary(healthy_female)
sum_healthy_male <- summary(healthy_male)
### export summary statistics for all European participants without exclusion
### both
write.csv(sum_healthy, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cat_european_healthy.csv", quote = F)
### female
write.csv(sum_healthy_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cat_european_healthy_female.csv", quote = F)
### male
write.csv(sum_healthy_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cat_european_healthy_male.csv", quote = F)


### identify numeric columns
numeric_columns_healthy <- sapply(healthy, is.numeric)
### write continuous sumstats
##sex-combined
summary_statistics_healthy <- basicStats(healthy[, numeric_columns_healthy])
write.csv(summary_statistics_healthy, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cont_european_healthy_both.csv", quote = F)
##female
summary_statistics_healthy_female <- basicStats(healthy_female[, numeric_columns_healthy])
write.csv(summary_statistics_healthy_female, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cont_european_healthy_female.csv", quote = F)
##male
summary_statistics_healthy_male <- basicStats(healthy_male[, numeric_columns_healthy])
write.csv(summary_statistics_healthy_male, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/healthy/phenotypic_stats_cont_european_healthy_male.csv", quote = F)


##### export after exclusion criteria
write.table(healthy, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/healthy/phenotypes_european_healthy.txt", sep = ""), quote = F, col.names = T, row.names = F)

