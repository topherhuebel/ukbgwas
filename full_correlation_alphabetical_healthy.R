#### phenotypic correlations

#### variables to change
### p value correction
number_of_independent_tests = 10
#number_of_studies = 22

####adjust pvalue
#P_bonferroni <- 0.05/(length(gen_correl$p)/2 - number_of_studies)
#P_bonferroni
P_corrected_matrix_decomposition <- 0.05/number_of_independent_tests
P_corrected_matrix_decomposition

####### select here #####
### select correction 
#P_correction = P_bonferroni
P_correction = P_corrected_matrix_decomposition


## install package
#install.packages("ppcor")
#install.packages("corrplot")

# libraries needed
library(corrplot)

### pvalues for the correlation
# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

### colours for correlation matrix
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))

### load phenotypes
final_complete <- read.table(file=paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes_after_exclusion.txt", sep = ""), header = TRUE)

#####################
## reduce dataframe 2
final_complete2 <- final_complete[,1:17]
final_complete2$IID <- NULL
final_complete2$Passed_QC_both<- NULL
final_complete2$Centre <- NULL
final_complete2$Current_tobacco <- NULL
final_complete2$Alcohol_frequency <- NULL
final_complete2$Age_squared <- final_complete2$Age * final_complete2$Age

#### reduce dataframe 3
final_complete3 <- final_complete2[,c("Gender","Age","Height", "Weight", "BMI","WC", "HC", "BFPC", "FM", "FFM", "SES", "WHR", "Age_squared")]


#### new labels 2
colnames(final_complete2) <- c("Sex","Age", "SES",  "Weight", "BMI",  "Fat free mass (FFM)", "Fat mass (FM)", "Body fat %", "Height",  "Waist circumference", "Hip circumference",  "WHR", "Age2")

### female subset 2
final_complete2_female <- subset(final_complete2, Sex == 0)
nrow(final_complete2_female)
final_complete2_female$Sex <- NULL

### male subset 2
final_complete2_male <- subset(final_complete2, Sex == 1)
nrow(final_complete2_male)
final_complete2_male$Sex <- NULL


######################

#### new labels 3
colnames(final_complete3) <- c("Sex","Age","Height", "Weight", "BMI","Waist circumference", "Hip circumference", "Body fat %", "Fat mass (FM)", "Fat free mass (FFM)", "SES", "WHR", "Age2")

### female subset 3
final_complete3_female <- subset(final_complete3, Sex == 0)
nrow(final_complete3_female)
final_complete3_female$Sex <- NULL

### male subset 3
final_complete3_male <- subset(final_complete3, Sex == 1)
nrow(final_complete3_male)
final_complete3_male$Sex <- NULL



#############
#### 
# correlation 2
### both sexes
B <- cor(final_complete2)
# matrix of the p-value of the correlation
p.mat.both <- cor.mtest(final_complete2)

### print correlation matrix
write.table(B, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_healthy_both.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)

cex.before <- par("cex")
par(cex = 0.6)

png(height=1500, width=1500, pointsize=15, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_healthy_both.png")
corrplot(B, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.both, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)


# correlation
### males
M <- cor(final_complete2_male)
# matrix of the p-value of the correlation
p.mat.male <- cor.mtest(final_complete2_male)

### print correlation matrix
write.table(M, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_healthy_male.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)

cex.before <- par("cex")
par(cex = 0.6)

png(height=1400, width=1500, pointsize=15, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_healthy_male.png")
corrplot(M, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.male, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)

# correlation
### females
F <- cor(final_complete2_female)
# matrix of the p-value of the correlation
p.mat.female <- cor.mtest(final_complete2_female)

### print correlation matrix
write.table(F, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_healthy_female.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)


cex.before <- par("cex")
par(cex = 0.6)

png(height=1400, width=1500, pointsize=15, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_healthy_female.png")
corrplot(F, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.female, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)




##############################
################# 
# correlation 3
### both sexes
B <- cor(final_complete3)
# matrix of the p-value of the correlation
p.mat.both <- cor.mtest(final_complete3)

### print correlation matrix
write.table(B, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_main_healthy_both.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)

cex.before <- par("cex")
par(cex = 0.6)

png(height=1500, width=1500, pointsize=25, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_main_healthy_both.png")
corrplot(B, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.both, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)


# correlation
### males
M <- cor(final_complete3_male)
# matrix of the p-value of the correlation
p.mat.male <- cor.mtest(final_complete3_male)

### print correlation matrix
write.table(M, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_main_healthy_male.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)

cex.before <- par("cex")
par(cex = 0.6)

png(height=1500, width=1500, pointsize=25, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_main_healthy_male.png")
corrplot(M, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.male, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)

# correlation
### females
F <- cor(final_complete3_female)
# matrix of the p-value of the correlation
p.mat.female <- cor.mtest(final_complete3_female)

### print correlation matrix
write.table(F, file = "/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/pheno_correl_matrix_main_healthy_female.txt", col.names = TRUE, row.names = TRUE, quote = FALSE)

cex.before <- par("cex")
par(cex = 0.6)

png(height=1500, width=1500, pointsize=25, file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/correlations/alphabet/r_phenotype_main_healthy_female.png")
corrplot(F, method="color", col=col(200),  
         type="upper", order="alphabet", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat.female, sig.level = P_correction, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE,
         tl.cex = 1/par("cex"),
         cl.cex = 1/par("cex")
)
dev.off()

par(cex = cex.before)

