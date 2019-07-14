####    ANALYSIS OF DISTRIBUTION OF STAMPS IN BAETICA   #####
library(dendextend)

library(stats)
foo = read.csv("baezone.csv")
library(dplyr, warn.conflicts = FALSE)
#install.packages('dplyr', dependencies = TRUE) to install dependencies included
#install.packages('/home/mcotsar/Downloads/dplyr_0.7.4.tar.gz', repos=NULL, type='source') to install from exterior
library(reshape2)
#baeMatrix = acast(foo, id ~ site, value.var= "code")
#baeMatrix = acast(foo, site ~ site, value.var="code")
baeMatrix = acast(foo, site ~ code)
library(vegan)
baeDistance = vegdist(baeMatrix, method="horn")
#baeDistance = vegdist(baeMatrix, method= "horn", na.rm= TRUE) na.rm when data is missing. Read ?vedist
baeDistance
hclust(baeDistance)
#use summary to see the results
plot(hclust(baeDistance))

## COLORIZED DENDROGRAM DIFFERENT SETTLEMENTS 

model = hclust(baeDistance)
pepedend = as.dendrogram(model)

#regioncolors = c("red","blue","yellow")
all_workshop_label=labels(pepedend)
 #all_workshop_label=labels(pepedend)

 
all_regions = c()
color_regions=c("olivedrab","steelblue4","tomato")
for (leaf in 1:length(all_workshop_label)){
print(leaf)
reg=unique(foo$region[ foo$site == all_workshop_label[leaf]])
all_regions=c(all_regions,reg)
print(reg)

}


### MILITARY CAMPS VERSUS CIVIL SETLEMENTS  

all_regions = c()
color_regions=c("olivedrab","tomato", "darkgrey")
for (leaf in 1:length(all_workshop_label)){
print(leaf)
reg=unique(foo$locationtype[ foo$site == all_workshop_label[leaf]])
all_regions=c(all_regions,reg)
print(reg)

}

#######

labels_colors(pepedend,cex=1.5) = color_regions[all_regions]

par(mar=c(15,2,1,1))
plot(pepedend)


#to keep it 

pdf('dendrocolor5brit.pdf', width= 15, height=5)
#define the margen
par(mar=c(12,2,1,1))
plot(pepedend)
dev.off()



##plot matrix

library(reshape)
library(ggplot2)
roo <- melt(as.matrix(baeDistance))
ggplot(roo, aes(x=X1, y=X2, fill=value, label=round(value, 2))) + geom_raster() + geom_text() #always use X1, X2

#print the results
pdf('resultadosnew.pdf', width=15, height=8)    
plot(hclust(baeDistance))
dev.off()

#print the matrix
pdf('resultadosmatrix.pdf', width=35, height=10) 
ggplot(roo, aes(x=X1, y=X2, fill=value, label=round(value, 2))) + geom_raster() + geom_text()
dev.off()

#para contar de que datos se disponen

count(mydata$site) 
names(mydata) #para saber el nombre de los valores (columnas)

#check by different region: Hispalis, Corduba and Astigi. Download the baezone.csv
myData= subset(foo, region %in% c("Hispalis")) 


### FREQUENCY PLOT

library(ggplot2)

stamp = read.csv("baezone.csv")
ggplot(stamp, aes(y = region, x = code)) + geom_point()

#library plyr (no confuse with dplyr) to calculate the frequency of stamps
count(stamp$code)

#function table to see how many items have a variable table(stamp$code) for example

##doing a matrix 

library(ggplot2)

stamp = read.csv("baezone.csv")


#list of all the sites to make a matrix
sites=sort(unique(stamp$site))
#to add the regions
sites = unique(stamp[,c("site","region")])

#to order the lsi tof sites with the regions
sites = sites[order(sites$site),]

foo=as.matrix(table(unique(stamp[,c("site","code")])))
write.csv(foo,"matrixfoo.csv")

how to make a matrix

sites$foo = rowSums(foo)

pdf('frequency.pdf', width= 15, height=5)
ggplot(sites, aes(y=reorder(region, foo, FUN=sum), x=foo, fill=region)) + geom_jitter(col="grey50", alpha=0.5, shape=21, height=0.2, width=0.3, size=3) + scale_colour_manual(values=myPalette) + theme_bw() + theme(legend.position="None") + xlab("number of code stamps") + ylab("region")
dev.off()

#para adaptarlo al gráfico dendrograma con los mismos colores. No se puede usar si tenemos la paleta scale_colour_manual
ggplot(sites, aes(y=reorder(region, foo, FUN=sum), x=foo, fill=region)) + geom_jitter(col="grey50", alpha=0.5, shape=21, height=0.2, width=0.3, size=5) + scale_fill_manual(values=c("olivedrab","steelblue4","tomato")) + theme_bw() + theme(axis.text=element_text(size=13),legend.position="None") + xlab("Number of code stamps") + ylab("")


## HISTORIGRAM WITH FREQUENCY OF STAMPS (EXAMPLES)


library(ggplot2)
library(dplyr)

foo = read.csv("baezone.csv")
data = table(foo$site)
#doing without ggplot
hist(data,breaks=50)
df = as.data.frame(data)
ggplot(df, aes(x=Freq)) + geom_histogram()
#to scale (poner más junto básicamente)
ggplot(df, aes(x=Freq)) + geom_histogram()+scale_x_log10()

#add color, alpha is the transparency

ggplot(df, aes(x=Freq)) + geom_histogram(bins=30, fill="blue", col="grey", alpha=.4) + scale_x_log10()
ggplot(df, aes(x=Freq)) + geom_histogram(bins=30, fill="blue", col="grey", alpha=.3) + scale_x_log10() + labs(x="Number of Stamps", y="Frequency") + theme(panel.background = element_rect(fill = "white", colour = "grey50"))
#other example is use + theme_classic()
ggplot(df, aes(x=Freq)) + geom_histogram(bins=30, fill="lightcoral", col="gray25") + scale_x_log10() + labs(x="Number of Stamps", y="Frequency") + theme_classic()










