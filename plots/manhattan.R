###
args=commandArgs()

### folder name
phenotype = args[3]
phenotype

#### define phenotype
sample = args[4]
sample

### sex
sex1 = "male"
sex2 = "female"
sex3 = "full"
sex4 = "meta"

library(data.table)
library(lattice)

manhattan.plot<-function(chr, pos, pvalue, 
                         sig.level=5e-8, 
                         annotate=NULL, 
                         ann.default=list(),
                         should.thin=T, thin.pos.places=2, thin.logp.places=2, 
                         xlab=list(label="Chromosome", cex=2.5), 
                         ylab=list(label=expression(-log[10](p-value)), cex=2.5), font="Helvetica",
                         col=c("#A6D5FF","#2D587F"), panel.extra=NULL, pch=20, cex=0.8, main=main,...) {
  
  if (length(chr)==0) stop("chromosome vector is empty")
  if (length(pos)==0) stop("position vector is empty")
  if (length(pvalue)==0) stop("pvalue vector is empty")
  
  #make sure we have an ordered factor
  if(!is.ordered(chr)) {
    chr <- ordered(chr)
  } else {
    chr <- chr[,drop=T]
  }
  
  #make sure positions are in kbp
  if (any(pos>1e6)) pos<-pos/1e6;
  
  #calculate absolute genomic position
  #from relative chromosomal positions
  posmin <- tapply(pos,chr, min);
  posmax <- tapply(pos,chr, max);
  posshift <- head(c(0,cumsum(posmax)),-1);
  names(posshift) <- levels(chr)
  genpos <- pos + posshift[chr];
  getGenPos<-function(cchr, cpos) {
    p<-posshift[as.character(cchr)]+cpos
    return(p)
  }
  
  #parse annotations
  grp <- NULL
  ann.settings <- list()
  label.default<-list(x="peak",y="peak",adj=NULL, pos=3, offset=0.5, 
                      col=NULL, fontface=NULL, fontsize=NULL, show=F)
  parse.label<-function(rawval, groupname) {
    r<-list(text=groupname)
    if(is.logical(rawval)) {
      if(!rawval) {r$show <- F}
    } else if (is.character(rawval) || is.expression(rawval)) {
      if(nchar(rawval)>=1) {
        r$text <- rawval
      }
    } else if (is.list(rawval)) {
      r <- modifyList(r, rawval)
    }
    return(r)
  }
  
  if(!is.null(annotate)) {
    if (is.list(annotate)) {
      grp <- annotate[[1]]
    } else {
      grp <- annotate
    } 
    if (!is.factor(grp)) {
      grp <- factor(grp)
    }
  } else {
    grp <- factor(rep(1, times=length(pvalue)))
  }
  
  ann.settings<-vector("list", length(levels(grp)))
  ann.settings[[1]]<-list(pch=pch, col=col, cex=cex, fill=col, label=label.default)
  
  if (length(ann.settings)>1) { 
    lcols<-trellis.par.get("superpose.symbol")$col 
    lfills<-trellis.par.get("superpose.symbol")$fill
    for(i in 2:length(levels(grp))) {
      ann.settings[[i]]<-list(pch=pch, 
                              col=lcols[(i-2) %% length(lcols) +1 ], 
                              fill=lfills[(i-2) %% length(lfills) +1 ], 
                              cex=cex, label=label.default);
      ann.settings[[i]]$label$show <- T
    }
    names(ann.settings)<-levels(grp)
  }
  for(i in 1:length(ann.settings)) {
    if (i>1) {ann.settings[[i]] <- modifyList(ann.settings[[i]], ann.default)}
    ann.settings[[i]]$label <- modifyList(ann.settings[[i]]$label, 
                                          parse.label(ann.settings[[i]]$label, levels(grp)[i]))
  }
  if(is.list(annotate) && length(annotate)>1) {
    user.cols <- 2:length(annotate)
    ann.cols <- c()
    if(!is.null(names(annotate[-1])) && all(names(annotate[-1])!="")) {
      ann.cols<-match(names(annotate)[-1], names(ann.settings))
    } else {
      ann.cols<-user.cols-1
    }
    for(i in seq_along(user.cols)) {
      if(!is.null(annotate[[user.cols[i]]]$label)) {
        annotate[[user.cols[i]]]$label<-parse.label(annotate[[user.cols[i]]]$label, 
                                                    levels(grp)[ann.cols[i]])
      }
      ann.settings[[ann.cols[i]]]<-modifyList(ann.settings[[ann.cols[i]]], 
                                              annotate[[user.cols[i]]])
    }
  }
  rm(annotate)
  
  #reduce number of points plotted
  if(should.thin) {
    thinned <- unique(data.frame(
      logp=round(-log10(pvalue),thin.logp.places), 
      pos=round(genpos,thin.pos.places), 
      chr=chr,
      grp=grp)
    )
    logp <- thinned$logp
    genpos <- thinned$pos
    chr <- thinned$chr
    grp <- thinned$grp
    rm(thinned)
  } else {
    logp <- -log10(pvalue)
  }
  rm(pos, pvalue)
  gc()
  
  #custom axis to print chromosome names
  axis.chr <- function(side,...) {
    if(side=="bottom") {
      panel.axis(side=side, outside=T,
                 at=((posmax+posmin)/2+posshift),
                 labels=levels(chr), 
                 ticks=F, rot=0,
                 check.overlap=F,
                 text.cex = 1.8
      )
    } else if (side=="top" || side=="right") {
      panel.axis(side=side, draw.labels=F, ticks=F);
    }
    else {
      axis.default(side=side,...);
    }
  }
  
  #make sure the y-lim covers the range (plus a bit more to look nice)
  prepanel.chr<-function(x,y,...) { 
    A<-list();
    maxy<-ceiling(max(y, ifelse(!is.na(sig.level), -log10(sig.level), 0)))+.5;
    A$ylim=c(0,maxy);
    A;
  }
  
  xyplot(logp~genpos, chr=chr, groups=grp,
         axis=axis.chr, ann.settings=ann.settings,
         main=main,
         prepanel=prepanel.chr, scales=list(axs="i", cex=2.5, tick.number=8),
         panel=function(x, y, ..., getgenpos) {
           if(!is.na(sig.level)) {
             #add significance line (if requested)
             panel.abline(h=-log10(sig.level), lty=2);
           }
           panel.superpose(x, y, ..., getgenpos=getgenpos);
           if(!is.null(panel.extra)) {
             panel.extra(x,y, getgenpos, ...)
           }
         },
         panel.groups = function(x,y,..., subscripts, group.number) {
           A<-list(...)
           #allow for different annotation settings
           gs <- ann.settings[[group.number]]
           A$col.symbol <- gs$col[(as.numeric(chr[subscripts])-1) %% length(gs$col) + 1]    
           A$cex <- gs$cex[(as.numeric(chr[subscripts])-1) %% length(gs$cex) + 1]
           A$pch <- gs$pch[(as.numeric(chr[subscripts])-1) %% length(gs$pch) + 1]
           A$fill <- gs$fill[(as.numeric(chr[subscripts])-1) %% length(gs$fill) + 1]
           A$x <- x
           A$y <- y
           do.call("panel.xyplot", A)
           #draw labels (if requested)
           if(gs$label$show) {
             gt<-gs$label
             names(gt)[which(names(gt)=="text")]<-"labels"
             gt$show<-NULL
             if(is.character(gt$x) | is.character(gt$y)) {
               peak = which.max(y)
               center = mean(range(x))
               if (is.character(gt$x)) {
                 if(gt$x=="peak") {gt$x<-x[peak]}
                 if(gt$x=="center") {gt$x<-center}
               }
               if (is.character(gt$y)) {
                 if(gt$y=="peak") {gt$y<-y[peak]}
               }
             }
             if(is.list(gt$x)) {
               gt$x<-A$getgenpos(gt$x[[1]],gt$x[[2]])
             }
             do.call("panel.text", gt)
           }
         },
         xlab=xlab, ylab=ylab, 
         panel.extra=panel.extra, getgenpos=getGenPos, ...
  );
}

#### read in data file phenotype_sex1
phenotype_sex1 <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex1,".txt", sep = ""), header = TRUE)
### phenotype_sex1
png(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/plots/manhattan/",phenotype,"_",sample,"_maf0.01_",sex1,"_manhattan_function.png", sep = ""), width = 1400, height = 800)
print(
  manhattan.plot(phenotype_sex1$chr, phenotype_sex1$pos, phenotype_sex1$p, main =list(label=paste(phenotype," ",sex1, sep = ""), cex=2.0))
)
dev.off()


#### read in data file phenotype_sex2
phenotype_sex2 <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex2,".txt", sep = ""), header = TRUE)
### phenotype_sex2
png(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/plots/manhattan/",phenotype,"_",sample,"_maf0.01_",sex2,"_manhattan_function.png", sep = ""), width = 1400, height = 800)
print(
  manhattan.plot(phenotype_sex2$chr, phenotype_sex2$pos, phenotype_sex2$p, main =list(label=paste(phenotype," ",sex2, sep = ""), cex=2.0))
)
dev.off()

#### read in data file phenotype_sex3
phenotype_sex3 <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex3,".txt", sep = ""), header = TRUE)
### phenotype_sex3
png(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/plots/manhattan/",phenotype,"_",sample,"_maf0.01_",sex3,"_manhattan_function.png", sep = ""), width = 1400, height = 800)
print(
  manhattan.plot(phenotype_sex3$chr, phenotype_sex3$pos, phenotype_sex3$p, main =list(label=paste(phenotype," both", sep = ""), cex=2.0))
)
dev.off()

#### read in data file phenotype_sex4
phenotype_sex4 <- fread(input =paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/sex_sumstats/",phenotype,"_",sample,"_maf0.01_",sex4,"_pos.txt", sep = ""), header = TRUE)

### phenotype_sex4
png(paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/plots/manhattan/",phenotype,"_",sample,"_maf0.01_",sex4,"_manhattan_function.png", sep = ""), width = 1400, height = 800)
print(
  manhattan.plot(phenotype_sex4$chr, phenotype_sex4$pos, phenotype_sex4$Pvalue, main =list(label=paste(phenotype," ",sex4, sep = ""), cex=2.0))
)
dev.off()

