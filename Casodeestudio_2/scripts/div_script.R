


library("vioplot")
library("vegan")
library("ggplot2")

#analyseModel<-function(){} if you want to create a function use this line. Remember close with {}
model=read.csv("result.csv") 

#testing with the last simulations (when it seems more differences) 
#model=model[!is.na(model)]
model=model[model$time >= max(model$time)-1000,]  
lastItmodel=getLastIt(model)
#cubeCC=cubeC[cubeC$time >= max(cubeC$time)-1000,] 
#model=model[order(model$dist),]

#version ggplot2 boxplot
png("test_1.png")
ggplot(model, aes(factor(workshop),exterior_diam)) + geom_boxplot(fill = "slategray3", colour = "slategray")
dev.off()

#violin version
ggplot(model, aes(factor(workshop),exterior_diam)) + geom_violin(fill = "slategray3", colour = "slategray")

#normal version to test the exterior_diam
png("CYDS.png")
boxplot(model$exterior_diam ~ model$dist,ylab="exterior_rim",xlab="workshop",xaxt="n")
axis(1,labels=levels(model$workshop),at=1:length(unique(model$dist)))
dev.off()







