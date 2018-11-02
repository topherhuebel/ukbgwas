
#########################
###### plotting

#### libraries
library(ggplot2)
library(ggExtra)
library(gridExtra)

### read in sample-file1
final_complete <- read.table(file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/phenotypes/healthy/phenotypes_european_healthy.txt", header = TRUE)
### gender as factor
final_complete$Gender <- as.factor(final_complete$Gender)
#### read in variable and label file
variable_label <- read.csv(file="/mnt/lustre/groups/ukbiobank/usr/chris/500k/scripte/descriptives/variable_label_selected.csv", header = TRUE, row.names = 1)

#### make variable list
#variable_names <- names(final_complete)
#library(reshape2)
#variable_names_long <- melt(variable_names)
#write.csv(variable_names_long, file="/mnt/lustre/groups/ukbiobank/chris/output/body_composition/variable_names_long.txt", quote = FALSE)

attach(final_complete)

final_complete$Gender <- as.factor(final_complete$Gender)

for (i in 1:11) {
  for (j in 1:11){
    #########################
    ### Plot: Loop through variable label dataframe
    x_variable <- as.character(variable_label[i, "Variable"])
    x_variable
    x_label <- as.character(variable_label[i, "Label"])
    x_label
    y_variable <- as.character(variable_label[j, "Variable"])
    y_variable
    y_label <- as.character(variable_label[j, "Label"])
    y_label
    grouping <- "Gender"
    grouping
    
    ############
    ### plot (red and blue) poster
  
    scatterPlot <- ggplot(final_complete, aes_string(x=x_variable, y=y_variable, colour=grouping)) + 
      geom_point(size = 0.5) + 
      xlab(x_label) + 
      ylab(y_label) + 
      scale_colour_manual(values = c("#CC3D33", "#337FCC"), labels = c("Female", "Male")) + 
      labs(colour = "Gender") + 
      theme(legend.position=c(0,1), 
            legend.justification=c(0,1), 
            legend.title=element_text(size=18), 
            legend.text=element_text(size=18), 
            axis.title=element_text(size=18))
    scatterPlot
    
    # ggMarginal(scatterPlot, type = "density")
    
    # Marginal density plot of x (top panel)
    xdensity <- ggplot(final_complete, aes_string(x_variable, fill=grouping)) + 
      geom_density(alpha=.5) + 
      xlab(x_label) +
      ylab("Density") +
      scale_fill_manual(values = c("#CC3D33", "#337FCC")) + 
      theme(legend.position = "none",
            axis.title=element_text(size=18))
    xdensity
    
    # Marginal density plot of x (top panel)
    ydensity <- ggplot(final_complete, aes_string(y_variable, fill=grouping)) + 
      geom_density(alpha=.5) + 
      xlab(y_label) +
      ylab("Density") +
      scale_fill_manual(values = c("#CC3D33", "#337FCC")) + 
      theme(legend.position = "none",
            axis.title=element_text(size=18)) +
      coord_flip()
    ydensity
    
    blankPlot <- ggplot()+geom_blank(aes(1,1))+
      theme(plot.background = element_blank(), 
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), 
            panel.border = element_blank(),
            panel.background = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(), 
            axis.text.y = element_blank(),
            axis.ticks = element_blank()
      )
    
    png(filename = paste("/mnt/lustre/groups/ukbiobank/usr/chris/500k/output/body_composition/descriptives/scatterplots/healthy/",x_variable,"_", y_variable,"_healthy.png", sep = ""), width = 1000, height = 600, units = "px")
    grid.arrange(xdensity, blankPlot, scatterPlot, ydensity, 
                 ncol=2, nrow=2, widths=c(4, 1.4), heights=c(1.4, 4))
    dev.off()
    
 #   pdf(file= paste(x_variable,"_", y_variable,".pdf", sep = ""), width = 13.33, height = 8)
#  grid.arrange(xdensity, blankPlot, scatterPlot, ydensity, 
#                 ncol=2, nrow=2, widths=c(4, 1.4), heights=c(1.4, 4))
 #   dev.off()
  }}


