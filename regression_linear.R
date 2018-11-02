################ Regression to calculate residuals ###############

###
args=commandArgs()

### folder name
folder = args[3]
folder

#### define phenotype
phenotype = args[4]
phenotype

### sex
sex1 = "male"
sex2 = "female"
sex3 = "both"

### dependent variable for regression
depv = args[5]
depv

###### call libraries
library(pbkrtest)
library(car)
library(lmtest)

# Stepwise Regression
#library(MASS)
#step <- stepAIC(bfpc_regression_full, direction="both")
#step$anova # display results

##### Genotypes #####
### import
genotypes <- read.table(file = "/mnt/lustre/groups/ukbiobank/KCL_Data/Genotypes/Chris_July_2017/ukb2754_imp_chr1_v2_s487398.sample", header = TRUE)
genotypes$missing <- NULL
genotypes$ID_2 <- NULL
### add index column
genotypes$gen_ID<-seq.int(nrow(genotypes))
nrow(genotypes)
# 487410


####### import data ########
##### import complete without exclusion #######
complete <- read.table(file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes_european_complete.txt", header = T)
nrow(complete)
# 353972
### Female
complete_female <- subset(complete, Gender == 0)
nrow(complete_female)
# 180765
### Male
complete_male <- subset(complete, Gender == 1)
nrow(complete_male)
# 173207


####### import healthy complete ######
### import data
healthy <- read.table(file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes_after_exclusion_selfreport.txt", header = T)
nrow(healthy)
# 155961
### Female
healthy_female <- subset(healthy, Gender == 0)
nrow(healthy_female)
# 70700
### Male
healthy_male <- subset(healthy, Gender == 1)
nrow(healthy_male)
# 85261


####### import healthy complete an free ######
### import data
healthy_anfree <- read.table(file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes_an_free.txt", header = T)
nrow(healthy_anfree)
# 154358
### Female
healthy_anfree_female <- subset(healthy_anfree, Gender == 0)
nrow(healthy_anfree_female)
# 69193
### Male
healthy_anfree_male <- subset(healthy_anfree, Gender == 1)
nrow(healthy_anfree_male)
# 85165


######### Regression############

varscombined <- "Gender + Age + SES + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + Centre_11011 + Centre_11009 + Centre_11021 + Centre_11016 + 
Centre_11014 + Centre_11010 + Centre_11017 + Centre_11013 + Centre_11004 + Centre_11018 + Centre_11022 + Centre_11006 + Centre_11001 + 
Centre_11008 + Centre_11020 + Centre_11007 + Centre_11003 + Centre_11012 + Centre_11005 + Centre_11002 + Centre_10003 + Batch_Batch_b001 + 
Batch_Batch_b002 + Batch_Batch_b003 + Batch_Batch_b004 + Batch_Batch_b005 + Batch_Batch_b006 + Batch_Batch_b007 + Batch_Batch_b008 + 
Batch_Batch_b009 + Batch_Batch_b010 + Batch_Batch_b011 + Batch_Batch_b012 + Batch_Batch_b013 + Batch_Batch_b014 + Batch_Batch_b015 + 
Batch_Batch_b016 + Batch_Batch_b017 + Batch_Batch_b018 + Batch_Batch_b019 + Batch_Batch_b020 + Batch_Batch_b021 + Batch_Batch_b022 + 
Batch_Batch_b023 + Batch_Batch_b024 + Batch_Batch_b025 + Batch_Batch_b026 + Batch_Batch_b027 + Batch_Batch_b028 + Batch_Batch_b029 + 
Batch_Batch_b030 + Batch_Batch_b031 + Batch_Batch_b032 + Batch_Batch_b033 + Batch_Batch_b034 + Batch_Batch_b035 + Batch_Batch_b036 + 
Batch_Batch_b037 + Batch_Batch_b038 + Batch_Batch_b039 + Batch_Batch_b040 + Batch_Batch_b041 + Batch_Batch_b042 + Batch_Batch_b043 + 
Batch_Batch_b044 + Batch_Batch_b045 + Batch_Batch_b046 + Batch_Batch_b047 + Batch_Batch_b048 + Batch_Batch_b049 + Batch_Batch_b050 + 
Batch_Batch_b051 + Batch_Batch_b052 + Batch_Batch_b053 + Batch_Batch_b054 + Batch_Batch_b055 + Batch_Batch_b056 + Batch_Batch_b057 + 
Batch_Batch_b058 + Batch_Batch_b059 + Batch_Batch_b060 + Batch_Batch_b061 + Batch_Batch_b062 + Batch_Batch_b063 + Batch_Batch_b064 + 
Batch_Batch_b065 + Batch_Batch_b066 + Batch_Batch_b067 + Batch_Batch_b068 + Batch_Batch_b069 + Batch_Batch_b070 + Batch_Batch_b071 + 
Batch_Batch_b072 + Batch_Batch_b073 + Batch_Batch_b074 + Batch_Batch_b075 + Batch_Batch_b076 + Batch_Batch_b077 + Batch_Batch_b078 + 
Batch_Batch_b079 + Batch_Batch_b080 + Batch_Batch_b081 + Batch_Batch_b082 + Batch_Batch_b083 + Batch_Batch_b084 + Batch_Batch_b085 + 
Batch_Batch_b086 + Batch_Batch_b087 + Batch_Batch_b088 + Batch_Batch_b089 + Batch_Batch_b090 + Batch_Batch_b091 + Batch_Batch_b092 + 
Batch_Batch_b093 + Batch_Batch_b094 + Batch_Batch_b095 + Batch_UKBiLEVEAX_b1 + Batch_UKBiLEVEAX_b2 + Batch_UKBiLEVEAX_b3 + Batch_UKBiLEVEAX_b4 + 
Batch_UKBiLEVEAX_b5 + Batch_UKBiLEVEAX_b6 + Batch_UKBiLEVEAX_b7 + Batch_UKBiLEVEAX_b8 + Batch_UKBiLEVEAX_b9 + Batch_UKBiLEVEAX_b10 + Alcohol_frequency_1 + 
Alcohol_frequency_2 + Alcohol_frequency_3 + Alcohol_frequency_4 + Alcohol_frequency_5 + Current_tobacco_1 + Current_tobacco_2 + Menopause_bin"

varsstratified <- "Age + SES + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + Centre_11011 + Centre_11009 + Centre_11021 + Centre_11016 + 
Centre_11014 + Centre_11010 + Centre_11017 + Centre_11013 + Centre_11004 + Centre_11018 + Centre_11022 + Centre_11006 + 
Centre_11001 + Centre_11008 + Centre_11020 + Centre_11007 + Centre_11003 + Centre_11012 + Centre_11005 + Centre_11002 + 
Centre_10003 + Batch_Batch_b001 + Batch_Batch_b002 + Batch_Batch_b003 + Batch_Batch_b004 + Batch_Batch_b005 + Batch_Batch_b006 + 
Batch_Batch_b007 + Batch_Batch_b008 + Batch_Batch_b009 + Batch_Batch_b010 + Batch_Batch_b011 + Batch_Batch_b012 + Batch_Batch_b013 + 
Batch_Batch_b014 + Batch_Batch_b015 + Batch_Batch_b016 + Batch_Batch_b017 + Batch_Batch_b018 + Batch_Batch_b019 + Batch_Batch_b020 + 
Batch_Batch_b021 + Batch_Batch_b022 + Batch_Batch_b023 + Batch_Batch_b024 + Batch_Batch_b025 + Batch_Batch_b026 + Batch_Batch_b027 + 
Batch_Batch_b028 + Batch_Batch_b029 + Batch_Batch_b030 + Batch_Batch_b031 + Batch_Batch_b032 + Batch_Batch_b033 + Batch_Batch_b034 + 
Batch_Batch_b035 + Batch_Batch_b036 + Batch_Batch_b037 + Batch_Batch_b038 + Batch_Batch_b039 + Batch_Batch_b040 + Batch_Batch_b041 + 
Batch_Batch_b042 + Batch_Batch_b043 + Batch_Batch_b044 + Batch_Batch_b045 + Batch_Batch_b046 + Batch_Batch_b047 + Batch_Batch_b048 + 
Batch_Batch_b049 + Batch_Batch_b050 + Batch_Batch_b051 + Batch_Batch_b052 + Batch_Batch_b053 + Batch_Batch_b054 + Batch_Batch_b055 + 
Batch_Batch_b056 + Batch_Batch_b057 + Batch_Batch_b058 + Batch_Batch_b059 + Batch_Batch_b060 + Batch_Batch_b061 + Batch_Batch_b062 + 
Batch_Batch_b063 + Batch_Batch_b064 + Batch_Batch_b065 + Batch_Batch_b066 + Batch_Batch_b067 + Batch_Batch_b068 + Batch_Batch_b069 + 
Batch_Batch_b070 + Batch_Batch_b071 + Batch_Batch_b072 + Batch_Batch_b073 + Batch_Batch_b074 + Batch_Batch_b075 + Batch_Batch_b076 + 
Batch_Batch_b077 + Batch_Batch_b078 + Batch_Batch_b079 + Batch_Batch_b080 + Batch_Batch_b081 + Batch_Batch_b082 + Batch_Batch_b083 + 
Batch_Batch_b084 + Batch_Batch_b085 + Batch_Batch_b086 + Batch_Batch_b087 + Batch_Batch_b088 + Batch_Batch_b089 + Batch_Batch_b090 + 
Batch_Batch_b091 + Batch_Batch_b092 + Batch_Batch_b093 + Batch_Batch_b094 + Batch_Batch_b095 + Batch_UKBiLEVEAX_b1 + Batch_UKBiLEVEAX_b2 + 
Batch_UKBiLEVEAX_b3 + Batch_UKBiLEVEAX_b4 + Batch_UKBiLEVEAX_b5 + Batch_UKBiLEVEAX_b6 + Batch_UKBiLEVEAX_b7 + Batch_UKBiLEVEAX_b8 + 
Batch_UKBiLEVEAX_b9 + Batch_UKBiLEVEAX_b10 + Alcohol_frequency_1 + Alcohol_frequency_2 + Alcohol_frequency_3 + Alcohol_frequency_4 + 
Alcohol_frequency_5 + Current_tobacco_1 + Current_tobacco_2 + Menopause_bin"

formcombined <- as.formula(paste(phenotype, "~", varscombined))
formcombined
formstratified <- as.formula(paste(phenotype, "~", varsstratified))
formstratified

###### complete data set #########
### sex-combined (excluding Centre_11023, Batch_UKBiLEVEAX_b11,  Alcohol_frequency_6 = Never, Current_tobacco_0 = Never)
complete_regression_full <- lm(formcombined, 
                           data = complete)

#### female
complete_regression_female <- lm(formstratified, 
                                    data = complete_female)

#### male
complete_regression_male <- lm(formstratified, 
                                      data = complete_male)


######### healthy data set #########
###### complete data set #########
### sex-combined (excluding Centre_11023, Batch_UKBiLEVEAX_b11,  Alcohol_frequency_6 = Never, Current_tobacco_0 = Never)
healthy_regression_full <- lm(formcombined, 
                                    data = healthy)

#### female
healthy_regression_female <- lm(formstratified, 
                                      data = healthy_female)

#### male
healthy_regression_male <- lm(formstratified, 
                                    data = healthy_male)

######### healthy_anfree data set #########
###### complete data set #########
### sex-combined (excluding Centre_11023, Batch_UKBiLEVEAX_b11,  Alcohol_frequency_6 = Never, Current_tobacco_0 = Never)
healthy_anfree_regression_full <- lm(formcombined, 
                                     data = healthy_anfree)

#### female
healthy_anfree_regression_female <- lm(formstratified, 
                                       data = healthy_anfree_female)

#### male
healthy_anfree_regression_male <- lm(formstratified, 
                                     data = healthy_anfree_male)



###### Regression output: Complete participants #######
### Model residuals
complete_residuals_full <- as.data.frame(resid(complete_regression_full))
complete_residuals_female <- as.data.frame(resid(complete_regression_female))
complete_residuals_male <- as.data.frame(resid(complete_regression_male))

### Plot residuals
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_residuals_full_model.pdf", sep =""))
plot(complete_regression_full, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_residuals_female_model.pdf", sep =""))
plot(complete_regression_female, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_residuals_male_model.pdf", sep =""))
plot(complete_regression_male, which=1)
dev.off()

### Autocorrelation (Durbin-Watson Test) - two-sided includes a possible negative autocorrelation
#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_full_autocorrelation.csv", sep = ""))
#dwtest(complete_regression_full, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_female_autocorrelation.csv", sep = ""))
#dwtest(complete_regression_female, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_male_autocorrelation.csv", sep = ""))
#dwtest(complete_regression_male, alternative="two.sided")
#sink()

### Plot of the autocorrelations of the residuals
#pdf("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/complete_regression_autocorrelation_plot.pdf")
#acf(complete_regression_full)
#dev.off()

### Key statistics
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_full_summary_stats.csv", sep=""))
summary(complete_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_female_summary_stats.csv", sep=""))
summary(complete_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_male_summary_stats.csv", sep=""))
summary(complete_regression_male)
sink()

#### complete_regression plots
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_full_plots.pdf", sep =""))
plot(complete_regression_full)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_female_plots.pdf", sep =""))
plot(complete_regression_female)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_male_plots.pdf", sep =""))
plot(complete_regression_male)
dev.off()

####Confidence intervals for the complete_regression coefficients
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_full_CI95.csv", sep=""))
confint(complete_regression_full, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_female_CI95.csv", sep=""))
confint(complete_regression_female, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_male_CI95.csv", sep=""))
confint(complete_regression_male, level=0.95)
sink()

### Identify outliers
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_full_outlier.csv", sep=""))
outlierTest(complete_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_female_outlier.csv", sep=""))
outlierTest(complete_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_complete_regression_male_outlier.csv", sep=""))
outlierTest(complete_regression_male)
sink()

###### control residuals calculated
head(complete_residuals_full)
head(complete_residuals_female)
head(complete_residuals_male)


###### Regression output: Healthy participants #######
### Model residuals
healthy_residuals_full <- as.data.frame(resid(healthy_regression_full))
healthy_residuals_female <- as.data.frame(resid(healthy_regression_female))
healthy_residuals_male <- as.data.frame(resid(healthy_regression_male))

### Plot residuals
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_residuals_full_model.pdf", sep =""))
plot(healthy_regression_full, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_residuals_female_model.pdf", sep =""))
plot(healthy_regression_female, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_residuals_male_model.pdf", sep =""))
plot(healthy_regression_male, which=1)
dev.off()

### Autocorrelation (Durbin-Watson Test) - two-sided includes a possible negative autocorrelation
#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_full_autocorrelation.csv", sep = ""))
#dwtest(healthy_regression_full, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_female_autocorrelation.csv", sep = ""))
#dwtest(healthy_regression_female, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_male_autocorrelation.csv", sep = ""))
#dwtest(healthy_regression_male, alternative="two.sided")
#sink()

### Plot of the autocorrelations of the residuals
#pdf("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/healthy_regression_autocorrelation_plot.pdf")
#acf(healthy_regression_full)
#dev.off()

### Key statistics
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_full_summary_stats.csv", sep=""))
summary(healthy_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_female_summary_stats.csv", sep=""))
summary(healthy_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_male_summary_stats.csv", sep=""))
summary(healthy_regression_male)
sink()

#### healthy_regression plots
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_full_plots.pdf", sep =""))
plot(healthy_regression_full)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_female_plots.pdf", sep =""))
plot(healthy_regression_female)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_male_plots.pdf", sep =""))
plot(healthy_regression_male)
dev.off()

####Confidence intervals for the healthy_regression coefficients
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_full_CI95.csv", sep=""))
confint(healthy_regression_full, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_female_CI95.csv", sep=""))
confint(healthy_regression_female, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_male_CI95.csv", sep=""))
confint(healthy_regression_male, level=0.95)
sink()

### Identify outliers
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_full_outlier.csv", sep=""))
outlierTest(healthy_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_female_outlier.csv", sep=""))
outlierTest(healthy_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_regression_male_outlier.csv", sep=""))
outlierTest(healthy_regression_male)
sink()

###### control residuals calculated
head(healthy_residuals_full)
head(healthy_residuals_female)
head(healthy_residuals_male)



###### Regression output: healthy_anfree participants #######
### Model residuals
healthy_anfree_residuals_full <- as.data.frame(resid(healthy_anfree_regression_full))
healthy_anfree_residuals_female <- as.data.frame(resid(healthy_anfree_regression_female))
healthy_anfree_residuals_male <- as.data.frame(resid(healthy_anfree_regression_male))

### Plot residuals
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_residuals_full_model.pdf", sep =""))
plot(healthy_anfree_regression_full, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_residuals_female_model.pdf", sep =""))
plot(healthy_anfree_regression_female, which=1)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_residuals_male_model.pdf", sep =""))
plot(healthy_anfree_regression_male, which=1)
dev.off()

### Autocorrelation (Durbin-Watson Test) - two-sided includes a possible negative autocorrelation
#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_full_autocorrelation.csv", sep = ""))
#dwtest(healthy_anfree_regression_full, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_female_autocorrelation.csv", sep = ""))
#dwtest(healthy_anfree_regression_female, alternative="two.sided")
#sink()

#sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_male_autocorrelation.csv", sep = ""))
#dwtest(healthy_anfree_regression_male, alternative="two.sided")
#sink()

### Plot of the autocorrelations of the residuals
#pdf("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/healthy_anfree_regression_autocorrelation_plot.pdf")
#acf(healthy_anfree_regression_full)
#dev.off()

### Key statistics
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_full_summary_stats.csv", sep=""))
summary(healthy_anfree_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_female_summary_stats.csv", sep=""))
summary(healthy_anfree_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_male_summary_stats.csv", sep=""))
summary(healthy_anfree_regression_male)
sink()

#### healthy_anfree_regression plots
pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_full_plots.pdf", sep =""))
plot(healthy_anfree_regression_full)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_female_plots.pdf", sep =""))
plot(healthy_anfree_regression_female)
dev.off()

pdf(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_male_plots.pdf", sep =""))
plot(healthy_anfree_regression_male)
dev.off()

####Confidence intervals for the healthy_anfree_regression coefficients
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_full_CI95.csv", sep=""))
confint(healthy_anfree_regression_full, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_female_CI95.csv", sep=""))
confint(healthy_anfree_regression_female, level=0.95)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_male_CI95.csv", sep=""))
confint(healthy_anfree_regression_male, level=0.95)
sink()

### Identify outliers
sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_full_outlier.csv", sep=""))
outlierTest(healthy_anfree_regression_full)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_female_outlier.csv", sep=""))
outlierTest(healthy_anfree_regression_female)
sink()

sink(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/",folder,"/",phenotype,"_healthy_anfree_regression_male_outlier.csv", sep=""))
outlierTest(healthy_anfree_regression_male)
sink()

###### control residuals calculated
head(healthy_anfree_residuals_full)
head(healthy_anfree_residuals_female)
head(healthy_anfree_residuals_male)



############ Merge IDs with residuals

#### subset of complete: IID
complete_full_without_residuals <- complete[, 1:2]
complete_female_without_residuals <- complete_female[, 1:2]
complete_male_without_residuals <- complete_male[, 1:2]

#### subset of healthy: IID
healthy_full_without_residuals <- healthy[, 1:2]
healthy_female_without_residuals <- healthy_female[, 1:2]
healthy_male_without_residuals <- healthy_male[, 1:2]

#### subset of healthy_anfree: IID
healthy_anfree_full_without_residuals <- healthy_anfree[, 1:2]
healthy_anfree_female_without_residuals <- healthy_anfree_female[, 1:2]
healthy_anfree_male_without_residuals <- healthy_anfree_male[, 1:2]

######## complete
##### add residuals to data frame
complete_full_with_residuals <- cbind(complete_full_without_residuals, complete_residuals_full)
names(complete_full_with_residuals)[names(complete_full_with_residuals) == "resid(complete_regression_full)"] <- paste(phenotype, "_residuals_c_full", sep = "")
### delete unnecessary column
complete_full_with_residuals$Gender <- NULL

##### add residuals to data frame
complete_female_with_residuals <- cbind(complete_female_without_residuals, complete_residuals_female)
names(complete_female_with_residuals)[names(complete_female_with_residuals) == "resid(complete_regression_female)"] <- paste(phenotype, "_residuals_c_female", sep = "")
### delete unnecessary column
complete_female_with_residuals$Gender <- NULL

##### add residuals to data frame
complete_male_with_residuals <- cbind(complete_male_without_residuals, complete_residuals_male)
names(complete_male_with_residuals)[names(complete_male_with_residuals) == "resid(complete_regression_male)"] <- paste(phenotype, "_residuals_c_male", sep = "")
### delete unnecessary column
complete_male_with_residuals$Gender <- NULL


######## healthy
##### add residuals to data frame
healthy_full_with_residuals <- cbind(healthy_full_without_residuals, healthy_residuals_full)
names(healthy_full_with_residuals)[names(healthy_full_with_residuals) == "resid(healthy_regression_full)"] <- paste(phenotype, "_residuals_h_full", sep = "")
healthy_full_with_residuals$Gender <- NULL

##### add residuals to data frame
healthy_female_with_residuals <- cbind(healthy_female_without_residuals, healthy_residuals_female)
names(healthy_female_with_residuals)[names(healthy_female_with_residuals) == "resid(healthy_regression_female)"] <- paste(phenotype, "_residuals_h_female", sep = "")
### delete unnecessary column
healthy_female_with_residuals$Gender <- NULL

##### add residuals to data frame
healthy_male_with_residuals <- cbind(healthy_male_without_residuals, healthy_residuals_male)
names(healthy_male_with_residuals)[names(healthy_male_with_residuals) == "resid(healthy_regression_male)"] <- paste(phenotype, "_residuals_h_male", sep = "")
### delete unnecessary column
healthy_male_with_residuals$Gender <- NULL

######## healthy_anfree
##### add residuals to data frame
healthy_anfree_full_with_residuals <- cbind(healthy_anfree_full_without_residuals, healthy_anfree_residuals_full)
names(healthy_anfree_full_with_residuals)[names(healthy_anfree_full_with_residuals) == "resid(healthy_anfree_regression_full)"] <- paste(phenotype, "_residuals_anfree_full", sep = "")
healthy_anfree_full_with_residuals$Gender <- NULL

##### add residuals to data frame
healthy_anfree_female_with_residuals <- cbind(healthy_anfree_female_without_residuals, healthy_anfree_residuals_female)
names(healthy_anfree_female_with_residuals)[names(healthy_anfree_female_with_residuals) == "resid(healthy_anfree_regression_female)"] <- paste(phenotype, "_residuals_anfree_female", sep = "")
### delete unnecessary column
healthy_anfree_female_with_residuals$Gender <- NULL

##### add residuals to data frame
healthy_anfree_male_with_residuals <- cbind(healthy_anfree_male_without_residuals, healthy_anfree_residuals_male)
names(healthy_anfree_male_with_residuals)[names(healthy_anfree_male_with_residuals) == "resid(healthy_anfree_regression_male)"] <- paste(phenotype, "_residuals_anfree_male", sep = "")
### delete unnecessary column
healthy_anfree_male_with_residuals$Gender <- NULL

##### merge residuals with genotype file ###########
### merge genotypes and phenotypes for both
nrow(genotypes)
nrow(healthy_full_with_residuals)
geno_hfull <- merge(genotypes,healthy_full_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull)
### merge genotypes and phenotypes for females
nrow(geno_hfull)
nrow(healthy_female_with_residuals)
geno_hfull_hfemale <- merge(geno_hfull,healthy_female_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale)
head(geno_hfull_hfemale)
### merge genotypes and phenotypes for males
nrow(geno_hfull_hfemale)
nrow(healthy_male_with_residuals)
geno_hfull_hfemale_hmale <- merge(geno_hfull_hfemale,healthy_male_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale)
head(geno_hfull_hfemale_hmale)

### merge genotypes and phenotypes for both
nrow(geno_hfull_hfemale_hmale)
nrow(complete_full_with_residuals)
geno_hfull_hfemale_hmale_cfull <- merge(geno_hfull_hfemale_hmale,complete_full_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull)
### merge genotypes and phenotypes for females
nrow(geno_hfull_hfemale_hmale_cfull)
nrow(complete_female_with_residuals)
geno_hfull_hfemale_hmale_cfull_cfemale <- merge(geno_hfull_hfemale_hmale_cfull,complete_female_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale)
head(geno_hfull_hfemale_hmale_cfull_cfemale)
### merge genotypes and phenotypes for males
nrow(geno_hfull_hfemale_hmale_cfull_cfemale)
nrow(complete_male_with_residuals)
geno_hfull_hfemale_hmale_cfull_cfemale_cmale <- merge(geno_hfull_hfemale_hmale_cfull_cfemale,complete_male_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale)
head(geno_hfull_hfemale_hmale_cfull_cfemale_cmale)


### merge genotypes and phenotypes for both
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale)
nrow(healthy_anfree_full_with_residuals)
geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull <- merge(geno_hfull_hfemale_hmale_cfull_cfemale_cmale,healthy_anfree_full_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull)
### merge genotypes and phenotypes for females
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull)
nrow(healthy_anfree_female_with_residuals)
geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale <- merge(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull,healthy_anfree_female_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale)
head(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale)
### merge genotypes and phenotypes for males
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale)
nrow(healthy_anfree_male_with_residuals)
geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale <- merge(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale,healthy_anfree_male_with_residuals,by.x="ID_1", by.y="IID", all = TRUE, sort = FALSE)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale)
head(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale)


#### order
geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered <- geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale[order(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale$gen_ID),]

head(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered)

geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered[1,3:ncol(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered)] <- "P"

head(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered)

geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered$gen_ID <- NULL

nrow(genotypes)
nrow(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered)

write.table(geno_hfull_hfemale_hmale_cfull_cfemale_cmale_affull_affemale_afmale_ordered, file = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/",phenotype,"_residuals.txt", sep = ""), quote = F, col.names = T, row.names = F)

