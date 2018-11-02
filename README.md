# ukbgwas
Scripts for body composition GWAS in UK Biobank


1)  Folder structure
2) Phenotype
* Extract columns from UKBB files (awk)
* Exclusion [phenotype_an_free.R]
* Descriptives
* Covariates
* Regression [regression_linear.R]
* Transfer descriptives into doc
* Make scatterplots [plotting_descriptives_healthy.R]
* Make phenotypic correlation matrix 
* Calculate independent tests
* Make correlation heatmap [full_correlation_alphabetical_healthy.R]
3) GWAS
* per chromosome [gwas_chr.sh]
4) Post-GWAS filtering [post_gwas_filtering/]
* Remove SNP duplicates [concatenate_filtering.sh] 
* Retain HRC SNPs
* Cocatenate to one sumstats file
4) Post-GWAS filtering 2 [post_gwas_filtering]
* MAF 0.01 [maf_0.01.sh]
5) Meta-analyse
* Metal [bfpc_h_metal_se.script & metal_jobscript_bfpc.sh]
6) Make sex-specific and metal files [sex_specific_sumstats_files/]
    * [sex_sumstats.sh]
    * [metal_sumstats.sh]
    * [add_pos_to_meta_sumstats.sh]
7) Extract gws SNPs [post_gwas_filtering/]
* Genome-wide significant SNPs [sign_snps.sh]
* gzip
* Put in spreadsheet
5) Plots [plots]
* qqplot
* sex-specific qqplot
* Manhattan plot
* Miami plot
6) Clumping
* FUMA
7) Annotate
* FUMA
8) LDSC [ldsc]
* Munge
* Calculate h2
* Put inflation statistics into table
* run rgs
9) Part heritability [ldsc_part_h2]
* submit script
