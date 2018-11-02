#!/users/k1596867/R/bin/Rscript

arg <- commandArgs(TRUE)

mymat <- read.csv(arg[1],header=T,sep="\t")

mymat$Coefficient_p_value <- 2*pnorm(-abs(mymat$Coefficient_z_score)) 
#qobj <- qvalue(p = mymat$COMP_P)
#mymat$qval <- qobj$qvalues
#mymat$NAME <- as.character(mymat$NAME)
#pdf(paste(arg[1],".p.pdf",sep=""))
#hist(mymat$COMP_P, nclass = 20)
#dev.off()
write.table(mymat,arg[1],row.names=F,col.names=T,quote=F,sep="\t")
