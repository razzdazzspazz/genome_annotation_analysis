#! /usr/bin/Rscript --vanilla

###############################################################################

args <- commandArgs(TRUE)

d <- read.table(args[1], header=TRUE, sep='\t', comment.char='', quote='') #This reads the file in


###############################################################################


pdf(args[2])		#This creates the file to write to
boxplot(d$gene.length ~ d$genome) #This generates a box and whiskers plot of genelength by genome

cat("\nThe results of the wilcox test are: \n") #A bit of formatting
wilcox.test(d$gene.length ~ d$genome)  #Tests whether the median genelength of the genomes are significantly different


#This creates a table that gives the frequency of each ECnumber in each genome (one row for each genome,
#one column for each EC number
ct <- table(d$genome, d$ec.num)
#plot(ct) #you didn't ask us to plot the table so I commented this out but you could easily do so by removing the # at the beginning of the line you could 
#print this to stdout easily by using the print() command instead of the plot() command
barplot(ct, beside = TRUE) #This plots the frequencies



################EXTRA CREDIT##########

##FIRST METHOD##########


#This is a way to plot the percentage of genes in each genome with a given level-2 ECnumber
#that does not involve your "hint"...I did some googling...

percentages <- prop.table(ct,1)
#print(percentages) #you didn't ask us to print the table to stdout so I commented this out
barplot(percentages, beside = TRUE) #this plots the percentages


##SECOND METHOD###########

#another way to plot the percentages (this is the way you hinted at in the directions):

ctpercentages <-table(d$genome, d$ec.num)/rowSums(ct)
#print (ctpercentages) #you didn't ask us to print the table to stdout so I commented this out
barplot(ctpercentages, beside = TRUE) #this plots the percentages


############################END##################################

###In all this script will return 4 results (plots) in a file called step4.pdf
### 1 box and whiskers plot of genelength by genome, 1 barplot tracking the FREQUENCY
### of genes with a given level-2 ECnumber for each genome, and 2 barplots tracking the PERCENTAGE
### of genes with a given level-2 ECnumber for each genome

###This script will also return the result of 1 wilcox test testing whether or not the median
###genelengths of each genome are significantly different to STDOUT: the medians are not statistically
###significantly different
