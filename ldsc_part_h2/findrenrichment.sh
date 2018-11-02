name=$1;
outputdir=$2;
#cleaned="$(echo "$outputdir" | sed -e 's/[()&]/\\&/g')"
cleaned=$(echo "$outputdir" | sed 's/\//\\\//g')

gawk 'NR==1{print}' ${outputdir}/${name}_Adrenal_Pancreas.results > ${outputdir}/header; grep "L2_0" ${outputdir}/${name}*.results > ${outputdir}/corpus; cat ${outputdir}/header ${outputdir}/corpus |gawk 'BEGIN{search["Enrichment"]; search["Enrichment_std_error"]; search["Enrichment_p"]; }NR==1{for(i=1;i<=NF;i++){arry[i]=$i}}{for(i=1;i<=NF;i++){if(arry[i] in search){printf $i"\t"}}printf $1"\n"}' |sed 's/:L2_0//g' |sed "s/${cleaned}\/${name}_//g" |sed "s/${cleaned}\/${name}//g" |sed "s/\.baseline//g" |sed 's/_baseline.results://g' |sed 's/.bedL2_0//g' |sed 's/.results://g' |sed 's/.results//g' | grep -v "baseL2_0"
