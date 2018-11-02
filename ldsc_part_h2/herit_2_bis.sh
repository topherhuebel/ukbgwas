name=$2
outputdir=$1

/mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/findrenrichment.sh ${name} ${outputdir} > ${outputdir}/${name}.enrich_data.tsv

/mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/findrH2_SNPS.sh ${name} ${outputdir} > ${outputdir}/${name}.h2_data.tsv

/mnt/lustre/groups/ukbiobank/usr/chris/software/part_h2/findscore.sh ${name} ${outputdir} > ${outputdir}/${name}.zscore_data.tsv


