
###
args=commandArgs()

### folder name
phenotype = args[3]
phenotype

#### define phenotype
sample = args[4]
sample

### sex
sex3 = "full"
sex4 = "meta"

library(data.table)

### add pos to meta

#### read in data file phenotype_sex3
phenotype_sex3 <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex3,".txt", sep = ""), header = TRUE)

positions <- phenotype_sex3[ ,list(rsid ,pos, info, beta, se, p)]
dim(positions)
colnames(positions)
head(positions)
colnames(positions) <- c("rsid","pos", "info", "beta_both", "se_both", "p_both")
colnames(positions)
head(positions)

#### read in data file phenotype_sex4
phenotype_sex4_less <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex4,".txt", sep = ""), header = TRUE)
dim(phenotype_sex4_less)

phenotype_sex4 <- merge(phenotype_sex4_less, positions, by.x = c("MarkerName"), by.y=c("rsid"))
dim(phenotype_sex4)
colnames(phenotype_sex4)

fwrite(x = phenotype_sex4, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex4,"_pos.txt", sep = ""), quote = F, col.names = T, sep = "\t")


