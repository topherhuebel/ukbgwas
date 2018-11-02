name=$1
outputdir=$2
cleaned=$(echo "$outputdir" | sed 's/\//\\\//g')
gawk 'NR==1{print}' ${outputdir}/${name}_Adrenal_Pancreas.results > ${outputdir}/header; grep "L2_0" ${outputdir}/${name}*.results > ${outputdir}/corpus; cat ${outputdir}/header ${outputdir}/corpus |gawk 'BEGIN{search["Prop._h2"];search["Prop._h2_std_error"];search["Prop._SNPs"]}NR==1{for(i=1;i<=NF;i++){arry[i]=$i}}{for(i=1;i<=NF;i++){if(arry[i] in search){printf $i"\t"}}printf $1"\n"}' |sed 's/:L2_0//g' |sed "s/${cleaned}\/${name}_//g" |sed "s/${cleaned}\/${name}//g" |sed "s/\.baseline//g" |sed 's/.bedL2_0//g' |sed 's/.results://g' |sed 's/.results//g' | grep -v "baseL2_0" | gawk '{print $2"\t"$3"\t"$1"\t"$4}' 
