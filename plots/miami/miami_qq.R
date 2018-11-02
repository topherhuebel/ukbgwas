#### Run EasyStrata for miami and sex qq plot

args=commandArgs()

### folder name
phenotype = args[3]
phenotype

#### define phenotype
sample = args[4]
sample


library(EasyStrata)

EasyStrata(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/",phenotype,"_",sample,"_miami.ecf", sep = ""))

EasyStrata(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/miami/",phenotype,"_",sample,"_qq.ecf", sep = ""))


