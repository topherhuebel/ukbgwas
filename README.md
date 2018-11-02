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
* Make scatterplots
* Make phenotypic correlation matrix
* Calculate independent tests
* Make correlation heatmap
3) GWAS
* per chromosome [gwas_chr.sh]
4) Post-GWAS filtering [post_gwas_filtering/]
* Remove SNP duplicates
* Retain HRC SNPs
* Cocatenate to one sumstats file
4) Post-GWAS filtering 2 [post_gwas_filtering]
* MAF 0.01 [maf_0.01.sh]
5) Meta-analyse
* Metal
6) Make sex-specific and metal files [sex_specific_sumstats_files/]
    * [sex_sumstats.sh]
    * [metal_sumstats.sh]
    * [add_pos_to_meta_sumstats.sh]
7) Extract gws SNPs [post_gwas_filtering/]
* Genome-wide significant SNPs [sign_snps.sh]
* gzip
* Put in spreadsheet
5) Plots
* qqplot
* sex-specific qqplot
* Manhattan plot
* Miami plot
6) Clumping
* Clump with plink [clumping_loop.sh]
* (Merge clumps with bedtool)
7) Annotate
* Prepare output file for RegionAnnotator
* RegionAnnotator
8) LDSC
* Munge
* Calculate h2
* Put inflation statistics into table
* run rgs
9) Pathway [pathway/]
* submit Helena’s script [qsub_SAMPLE.sh]
10) Part heritability [part_heritability/]
* submit Helenas script
11) Two sample mendelian randomisation
