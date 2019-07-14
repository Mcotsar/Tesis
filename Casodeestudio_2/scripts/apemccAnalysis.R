###Firs tthings:  load the file using : source("apemccAnalysis.R")

## then try to run the command that are inside the function analyseRealData(),analyseModelNotReal(),YSLR_man()

if(require("vioplot")){library(vioplot)}
if(require("vegan")){library(vegan)}
if(require("scales")){library(scales)}

##Some command use to analyse the output of the model used with theoretical distances and some examples
analyseModel<-function(){ # you want to create a function use this line. Remember close with {}

    model=read.csv("../singletest_N10.csv")  
    #model=model[!is.na(model)]
    model=model[model$time >= max(model$time)-1000,]
    lastItmodel=getIt(model)
    #cubeCC=cubeC[cubeC$time >= max(cubeC$time)-1000,]; 
    #model=model[order(model$dist),];


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

    #Check how size chang e through time for one workshop:
    boxplot(model$exterior_diam[model$workshop == "ws_1"] ~ model$time[model$workshop == "ws_1"],ylab="exterior_rim",xlab="time")

}

##Below a collection of commands used to explore the real data
## Exemple: to extract the mean of different measurement etc...
##and some graph test 
analyseRealData<-function(){

    boxplot(emp$protruding_rim ~ emp$site)
    cov(emp$rim_h,emp$rim_w)
    cor(emp$rim_h,emp$rim_w)
    cov(emp$exterior_diam,emp$rim_w)
    cor(emp$exterior_diam,emp$rim_h)
    plot(emp$exterior_diam~emp$inside_diam)
    cov(emp$exterior_diam,emp$inside_diam)
    abline(
	   lm(emp$exterior_diam~emp$rim_w)
	   )
    mean(tapply(emp$exterior_diam,emp$site,mean))
    tapply(emp$exterior_diam,emp$site,mean)
    sd(emp$exterior_diam)
    sd(tapply(cubeC$exterior_diam,cubeC$workshop,mean))
    sd(cubeC$exterior_diam)
    mean(tapply(model$exterior_diam,model$workshop,sd))
    sd(model$exterior_diam)

    apply(emp[,5:12],2,sd)/	apply(emp[,5:12],2,mean)
    summary=rbind(apply(emp[,5:12],2,sd),	apply(emp[,5:12],2,mean))

    vioplot2(emp,"site","protruding_rim")
    vioplot2(cubeC,"workshop","exterior_diam")

    ##Write the graph in pdf file (those are draft graoh)
    pdf("prot.pdf")
    vioplot2(emp,"site","protruding_rim",main="Size of the protruding rim in each workshop")
    dev.off()

    defN4=read.csv("../aaahou_N5.csv")
    vioplot2(defN4,"workshop","exterior_diam")

    defN5=read.csv("testE_N5.csv")
    vioplot2(defN5,"workshop","protruding_rim")

    defN5=read.csv("lineC/lineC_100_N5.csv")
    defN5=defN5[defN5$time == max(defN5$time),]
    vioplot2(getIt(defN5),"workshop","exterior_diam")
    sd(tapply(emp$exterior_diam,emp$site,mean))

    ##this three lines allow to see how the mean of the exterior diam evolve during time
    tsd=c()
    for(i in unique(defN4$time)){
	tsd=c(tsd,sd(tapply(defN4$exterior_diam[defN4$time==i],defN4$workshop[defN4$time==i],mean)))
    }
    plot(tsd)
    ##

    tapply(defN4$exterior_diam,defN4$workshop,sd)
    aa=varWorkshopTime(defN4)
    varOfVar=t(varSim(cubeC))
    timesel=seq(0,8000,2000)
    allExpeb=list(t(varSim(lineC[lineC$time %in% timesel ,])),
		  t(varSim(lineNC[lineNC$time %in% timesel ,])),
		  t(varSim(cubeC[cubeC$time %in% timesel ,])),
		  t(varSim(cubeNC[cubeNC$time %in% timesel ,]))
		  )
    #Graph used in birmindgham
    png("lineC.png")
    vioplot3(t(varSim(limitTimeStep(lineC,timesel) )),ylim=c(0,30),main="Evolution of interworkshop variance",ylab="Var in Exterior Diam. Mean. Size",xlab="Time")
    dev.off()
    png("lineNC.png")
    vioplot3(t(varSim(limitTimeStep(lineNC,timesel) )),ylim=c(0,30),main="Evolution of interworkshop variance",ylab="Var in Exterior Diam. Mean. Size",xlab="Time")
    dev.off()
    png("cubeC.png")
    vioplot3(t(varSim(limitTimeStep(cubeC,timesel) )),ylim=c(0,30),main="Evolution of interworkshop variance",ylab="Var in Exterior Diam. Mean. Size",xlab="Time")
    dev.off()
    png("cubeNC.png")
    vioplot3(t(varSim(limitTimeStep(cubeNC,timesel) )),ylim=c(0,30),main="Evolution of interworkshop variance",ylab="Var in Exterior Diam. Mean. Size",xlab="Time")
    dev.off()
    boxplot(t(varSim(cubeNC)))
    boxplot(t(varSim(lineC)))
    boxplot(t(varSim(lineNC)))
    cubeC=readFolder("cubeC/")
    vioplot2(cubeC,"workshop","exterior_diam")


    ##LAST GRAPH (preversions of the graphs used for manchester and deimburgh conf == the )
    all_extdiam=c()
    all_extdiam=rbind(
		 varSim(getIt(lineNC)),
		 varSim(getIt(cubeC)),
		 varSim(getIt(lineC))
		 )
    rownames(all_extdiam)=c("","","")#expression(frac(1,d^3)),"1/d")
    pdf("interworkshopvar.pdf",pointsize=20)
    vioplot3(t(all_extdiam),ylim=c(0,40),ylab="Interworkshops variation (cm)",xlab="P(T)",xaxt="n")
    axis(1,label=c("0",expression(1%/%d^3),expression(1%/%d)),at=1:3)
    dev.off()
    #axis(1,label=c("0",expression(frac(1,d^3)),expression(frac(1,d))),at=1:3)

    colnames(u)[ncol(u)]="PA"
    all_extdiam=rbind(all_extdiam,u)
    u=cbind(getIt(lineC),"lineC")
    colnames(u)[ncol(u)]="PA"
    all_extdiam=rbind(all_extdiam,u)
    u=cbind(getIt(cubeC),"cubeC")
    colnames(u)[ncol(u)]="PA"
    all_extdiam=rbind(all_extdiam,u)

    vioplot2(all_extdiam,"PA","exterior_diam")

    cubeC10=readFolder("cubeC10/")
    vioplot2(cubeC10,"workshop","exterior_diam")

    cubeNC=readFolder("cubeNC/")
    vioplot2(cubeNC,"workshop","exterior_diam")

}


#########CODE CAA 2017 EXAMPLES##################


YSLR_man   <-  function(){

    ##this allow to compact the result of the 100 simulation in one table
    ###!!warnings: you needs the folders
    #verti=readFolder("verti/")
    #hori=readFolder("hori/")
    #horiH=readFolder("horiH/")
    #horicube=readFolder("horiCub/")
    #horiM=readFolder("horiM/")
    #horiH=readFolder("horiH/")
    #horimas=readFolder("horimas/")
    
    verti=readFolder("VT/")
    horiH=readFolder("HT/")
    hori=readFolder("HTD/")
    
   
    ##a simple test to analyze the sample
    j=rbind(
	    varSim(getIt(verti),vari="protruding_rim"),
	    varSim(getIt(hori),vari="protruding_rim"),
	    varSim(getIt(horiH),vari="protruding_rim")
	    ) #=>> this allow to bind together the result of different model

    rownames(j)=c("VT","VT+HT(d)","VT+HT") #this allows to change the names of the models

    plotDensities(t(j),colnames(t(j))) #this plot the result of the previous command as 
    #######TESTING WITH MEASUREMENTS#########
    
    
    #charge the data
    
    emp <- getRealMeasurment() #load the mesuremant from data/drespaper.csv and remove Dressel 23
    # A simple function to :
    #load the mesuremant from data/drespaper.csv and remove Dressel 23
   
   
    #protruding_rim

    all_protrim=rbind(
	           varSim(getIt(verti),vari="protruding_rim"),
		   varSim(getIt(hori),vari="protruding_rim"),
		   varSim(getIt(horiH),vari="protruding_rim"))
		   #varSim(getIt(horimas))
    rownames(all_protrim)=c("VT","VT+HT(d)","VT+HT")
    #all_protrim contains the variation beetween workshop at the end of the simulation for all the model we want to compare

    pdf("images/PR_densities.pdf",pointsize=17)#if you just want to see the plot, don't execute those commands (and the dev.off())
    plotDensities(t(all_protrim),colnames(t(all_protrim)))
    abline(v=sd(tapply(emp$protruding_rim,emp$site,mean)),col="red",lwd=3) 
    text(sd(tapply(emp$protruding_rim,emp$site,mean))+0.8,.23,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()
    
    #exterior_diam

    all_extdiam=rbind(
		 varSim(getIt(verti),vari="exterior_diam"), #get last it allow to get the result of the last iteration and var sim allow to compute the variation of the mean between all diamter
		 varSim(getIt(hori),vari="exterior_diam"),
		 varSim(getIt(horiH),vari="exterior_diam")
		 )
    rownames(all_extdiam)=c("VT","VT+HT(d)","VT+HT")
    #all_extdiam contains the same that all_protrim but for the variation of exterior diameter 

    pdf("images/ED_densities.pdf",pointsize=17)
    plotDensities(t(all_extdiam),colnames(t(all_extdiam)))
    abline(v=sd(tapply(emp$exterior_diam,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$exterior_diam,emp$site,mean))+0.8,.25,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()
    
    #rim_w
    
    all_rim_w=rbind(
		 varSim(getIt(verti),vari="rim_w"), #get last it allow to get the result of the last iteration and var sim allow to compute the variation of the mean between all diamter
		 varSim(getIt(hori),vari="rim_w"),
		 varSim(getIt(horiH),vari="rim_w")
		 )
    rownames(all_rim_w)=c("VT","VT+HT(d)","VT+HT")
    #all_extdiam contains the same that all_protrim but for the variation of rim_w 

    pdf("images/rim_densities.pdf",pointsize=17)
    plotDensities(t(all_rim_w),colnames(t(all_rim_w)))
    abline(v=sd(tapply(emp$rim_w,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$rim_w,emp$site,mean))+0.8,.25,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()
     
    #rim_w_2
    
    all_rim_w_2=rbind(
		 varSim(getIt(verti),vari="rim_w_2"), #get last it allow to get the result of the last iteration and var sim allow to compute the variation of the mean between all diamter
		 varSim(getIt(hori),vari="rim_w_2"),
		 varSim(getIt(horiH),vari="rim_w_2")
		 )
    rownames(all_rim_w_2)=c("VT","VT+HT(d)","VT+HT")
    #all_extdiam contains the same that all_protrim but for the variation of rim_w 

    pdf("images/rim2_densities.pdf",pointsize=17)
    plotDensities(t(all_rim_w_2),colnames(t(all_rim_w_2)))
    abline(v=sd(tapply(emp$rim_w_2,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$rim_w_2,emp$site,mean))+0.8,.25,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()
    
    
    ##This are the old version of the graph (as used in edinburgh), with the vioplot in black and white
    pdf("images/PR_densities_vioplot.pdf",pointsize=17)
    vioplot3(t(all_protrim),ylim=c(0,max(all_protrim)),ylab="Interworkshops variation (cm)",xlab="P(T)",xaxt="n")
    abline(h=sd(tapply(emp$protruding_rim,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$protruding_rim,emp$site,mean))+0.8,.23,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()


    pdf("images/ED_densities_vioplot.pdf",pointsize=17)
    vioplot3(t(all_extdiam),ylim=c(0,max(all_extdiam)),ylab="Interworkshops variation (cm)",xlab="",xaxt="n")
    abline(h=sd(tapply(emp$exterior_diam,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$exterior_diam,emp$site,mean))+0.8,.25,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()


sapply(unique(verti$time),function(i){

  print(paste("time",i))
    curT=rbind(
		 varSim(verti[verti$time == i,],vari="exterior_diam"), #get last it allow to get the result of the last iteration and var sim allow to compute the variation of the mean between all diamter
		 varSim(hori[hori$time == i,],vari="exterior_diam"),
		 varSim(horiH[horiH$time == i,],vari="exterior_diam")
		 )
		 
    rownames(curT)=c("VT","VT+HT(d)","VT+HT")
    #all_extdiam contains the same that all_protrim but for the variation of rim_w 

    png(paste("images/rim2_time",i,".png",sep=""),pointsize=17)
    plotDensities(t(curT),colnames(t(curT)))
    abline(v=sd(tapply(emp$exterior_diam,emp$site,mean)),col="red",lwd=3)
    text(sd(tapply(emp$exterior_diam,emp$site,mean))+0.8,.25,"dataset variation of means",srt=90,col="red",cex=.7)
    dev.off()
})
    
    ###Draft trandom test
    vioplot2(getIt(verti),"workshop","exterior_diam")

    lineC=readFolder("lineC/")
    vioplot2(lineC,"workshop","exterior_diam")

    lineNC=readFolder("lineNC/")
    vioplot2(getIt(cubeNC),"workshop","exterior_diam")

    pn3C=readFolder("pn3/")
    vioplot3(t(varSim(limitTimeStep(pn3C,timesel) )),ylim=c(0,30),main="Evolution of interworkshop variance",ylab="Var in Exterior Diam. Mean. Size",xlab="Time")

    sd(lineNC$exterior_diam)
    sd(cubeC$exterior_diam)
    sd(getIt(lineC)$exterior_diam)
    sd(getIt(lineNC)$exterior_diam)

    diversity(getIt(cubeC)$exterior_diam)
    diversity(getIt(cubeNC)$exterior_diam)
    diversity(getIt(lineC)$exterior_diam)
    diversity(getIt(lineNC)$exterior_diam)
    diversity(emp$exterior_diam)
}



#vioplot 2
vioplot2<-function(data,x,y,...){
    levx=levels(data[,x])
    xmax=length(levx)

    ymax=max(data[,y])
    ymin=min(data[,y])
    plot(1,1,xlim=c(0.5,xmax+.5),ylim=c(ymin,ymax),type="n",xaxt="n",ylab="Size",xlab="",...)
    axis(1,at=1:xmax,labels=levx)
    sapply(1:xmax,function(k){
	   tmp=data[data[,x] == levx[k] , y ]
	   vioplot(tmp,at=k,add=T,col="white")
		 })
}

#vioplot 3
vioplot3<-function(data,...){
    levx=colnames(data)
    xmax=length(levx)

    ymax=max(data)
    ymin=min(data)
    #ylim=c(ymin,ymax),
    plot(1,1,xlim=c(0.5,xmax+.5),type="n",xaxt="n",...)
    axis(1,at=1:xmax,labels=levx)
    sapply(1:xmax,function(k){
	   tmp=data[ , k ]
	   vioplot(tmp,at=k,add=T,col="white")
		 })

}
#take list of truc and amkle truc
vioplot4<-function(data,...){
    levx=colnames(data[[1]])
    xmax=length(levx)

    ymax=max(sapply(data,max))
    ymin=min(sapply(data,min))
    plot(1,1,xlim=c(0.5,xmax+.5),ylim=c(ymin,ymax),type="n",xaxt="n",...)
    axis(1,at=1:xmax,labels=levx)
    for(i in 1:length(data)){
	tmp=data[[i]]
	sapply(1:xmax,function(k){
	       print(paste(i,k))
	       vioplot(tmp[ , k ],at=(k+.65)-(i/4),add=T,wex=.2,col=i)
		 })
    }

}


#This function read a folder with csv file resulting from the run of the model: It binds all files row by row and add a column to identify the simulation 
readFolder<-function(fname){
    res=c()
    id=0
    for(i in list.files(fname,pattern= "*.csv",full.names=T)){
	print(i)
	res=rbind(res,cbind(read.csv(i),id))
	id=id+1
    }
    return(res)
}

##This function return the measurment recorded during the last iteration of the simulation
getIt<-function(data,time="max"){
    if(time=="max")
      return(data[data$time >= max(data$time),])
    else
       return(data[data$time == time,])
      
}

#this function compute the evolution through time of the variation (the standard deviation of the mean) between workshop of the measurement *vari*
varWorkshopTime<-function(data,vari="exterior_diam"){
    sapply(unique(data$time),function(i){
	   r=sd(tapply(data[data$time==i,vari],data$workshop[data$time==i],mean))
	   names(r)=i
	   return(r)
		 })
}

##This function concatenate the variation a measurment var (cf previosu function) for different simulation
varSim<-function(data,vari="exterior_diam"){
    sapply(unique(data$id),function(i){
	   tmp=data[data$id == i,]
	   varWorkshopTime(tmp,vari=vari)
		 })
}

#return a subset of a daset for particular timeperiods
#(used to do more simple violin plotA)
limitTimeStep<-function(data,timelist){
    return(data[data$time %in% timelist ,])
}

##This function take a table with the variations of the mean size between workshop and a list of different model names and plot density plot ggplot style (take from ABC plot used with model CEEC)
plotDensities <- function(datas,epsilon,...){
    htcol=heat.colors(length(epsilon),alpha=1)
    names(htcol)=epsilon
    htcolF=heat.colors(length(epsilon),alpha=.5)
    names(htcolF)=epsilon
    from=0
    to=max(datas)
    densities=lapply(colnames(datas),function(i){density(datas[,i],from=from,to=to)})
    names(densities)=colnames(datas)
    rangex=range(lapply(densities,function(i)range(i$x)))
    rangey=range(lapply(densities,function(i)range(i$y)))
    par(mar=c(5,5,1,1))
    plot(density(datas),xlim=rangex,ylim=rangey,type="n",xlab="Variation of the mean size per workshop",...)
    lapply(seq_along(densities),function(i){
	   polygon(c(0,densities[[i]]$x,to),c(0,densities[[i]]$y,0),col=htcolF[names(densities)[i]],lwd=2)#,density=20,angle=45*i,border=htcol[names(densities)[i]])
	   #polygon(densities[[i]],col=htcolF[names(densities)[i]],lwd=2)#,density=20,angle=45*i,border=htcol[names(densities)[i]])
	   #	   abline(v=mean(densities[[i]]$x),col=htcol[names(densities)[i]])
	   #	   text(mean(densities[[i]]$x),0,names(densities)[i],col=htcol[names(densities)[i]])
		 })
    legend("topright",legend=epsilon,fill=htcolF,title="model")
}

##Fucntion that bind together the result of differents model for one particular timestep (max by default) 
bindTimeStep<-function(list,time="max",var){
#   res=c()
#   sapply(list, function(model){      
#       res=rbind(res,varSim(getIt(model,time),vari=var))
#   })
#   return(res)
#   
  
    res=rbind(
	           varSim(getIt(list[["verti"]],time),vari=var),
		   varSim(getIt(list[["hori"]],time),vari=var),
		   varSim(getIt(list[["horiH"]],time),vari=var))
		   #varSim(getIt(horimas))
    rownames(res)=c("VT","VT+HT(d)","VT+HT")
  return(res)
}
  

plotDensitiesTimeStep<-function(list,time,var){
  tmp=bindTimeStep(list,time,var)
  plotDensities(t(tmp),colnames(t(tmp)), main="")
  abline(v=sd(tapply(emp[,var],emp$site,mean)),col="red",lwd=3) 

}


testMaria<-function(){
test1= list(   
    verti=readFolder("test1/VT/"),
    horiH=readFolder("test1/HT/"),
    hori=readFolder("test1/HTD/")
    )
 
plotDensitiesTimeStep(test1,30000,"protruding_rim")
nosd= list(   
    verti=readFolder("nosd/VT/"),
    horiH=readFolder("nosd/HT/"),
    hori=readFolder("nosd/HTD/")
    )
onsdlow= list(   
    verti=readFolder("onsdlow/VT/"),
    horiH=readFolder("onsdlow/HT/"),
    hori=readFolder("onsdlow/HTD/")
    )
 
twosd= list(   
    verti=readFolder("twosd/VT/"),
    horiH=readFolder("twosd/HT/"),
    hori=readFolder("twosd/HTD/")
    )

onesd= list(   
	    verti=readFolder("onsd/VT/"),
    horiH=readFolder("onsd//HT/"),
    hori=readFolder("onsd//HTD/")
    )
dweightBIGPRODB= list(   
	    verti=readFolder("dweightBIGPRODB/VT/"),
    horiH=readFolder("dweightBIGPRODB//HT/"),
    hori=readFolder("dweightBIGPRODB//HTD/")
    )
pcopy1= list(   
	    verti=readFolder("pcopy1/VT/"),
    horiH=readFolder("pcopy1//HT/"),
    hori=readFolder("pcopy1//HTD/")
    )

pcopy= list(   
	    verti=readFolder("pcopy1pmut0005/VT/"),
    horiH=readFolder("pcopy1pmut0005//HT/"),
    hori=readFolder("pcopy1pmut0005/HTD/")
    )

pcopy1= list(   
	    verti=readFolder("pcopy1pmut0005/VT/"),
    horiH=readFolder("pcopy1pmut0005//HT/"),
    hori=readFolder("pcopy1pmut0005/HTD/")
    )
dweightBIGPROD= list(   
	    verti=readFolder("dweightBIGPROD/VT/"),
    horiH=readFolder("dweightBIGPROD//HT/"),
    hori=readFolder("dweightBIGPROD//HTD/")
    )
dweightM= list(   
	    verti=readFolder("dweightM/VT/"),
    horiH=readFolder("dweightM//HT/"),
    hori=readFolder("dweightM//HTD/")
    )
dweight= list(   
	    verti=readFolder("dweight/VT/"),
    horiH=readFolder("dweight//HT/"),
    hori=readFolder("dweight//HTD/")
    )

aGoodOne= list(   
	    verti=readFolder("aGoodOne//VT/"),
    horiH=readFolder("aGoodOne//HT/"),
    hori=readFolder("aGoodOne//HTD/")
    )

testGALGAL= list(   
	    verti=readFolder("testGALGAL/VT/"),
    horiH=readFolder("testGALGAL//HT/"),
    hori=readFolder("testGALGAL//HTD/")
    )
 
plotDensitiesTimeStep(nosd,10000,"protruding_rim")
plotDensitiesTimeStep(twosd,10000,"exterior_diam")
plotDensitiesTimeStep(onesd,10000,"exterior_diam")
plotDensitiesTimeStep(onsdlow,10000,"exterior_diam")
plotDensitiesTimeStep(dweightBIGPROD,20000,"exterior_diam")
plotDensitiesTimeStep(dweightBIGPRODB,20000,"exterior_diam")
plotDensitiesTimeStep(pcopy1,20000,"exterior_diam")
plotDensitiesTimeStep(pcopy1pmut0005,30000,"rim_w_2")
plotDensitiesTimeStep(dweight,20000,"protruding_rim")
plotDensitiesTimeStep(testGALGAL,30000,"rim_w_2")


####GRAPHS FOR ATLANTA
pdf("images/rim_w_2.pdf")
plotDensitiesTimeStep(aGoodOne,30000,"rim_w_2")
text(sd(tapply(emp[,"rim_w_2"],emp$site,mean))*1.1,.6,"dataset variation of means",srt=90,col="red",cex=.7)
dev.off()
pdf("images/rim_w.pdf")
plotDensitiesTimeStep(aGoodOne,30000,"rim_w")
text(sd(tapply(emp[,"rim_w"],emp$site,mean))*1.1,.6,"dataset variation of means",srt=90,col="red",cex=.7)
dev.off()
pdf("images/exterior_diam.pdf")
plotDensitiesTimeStep(aGoodOne,30000,"exterior_diam")
text(sd(tapply(emp[,"exterior_diam"],emp$site,mean))*1.2,.17,"dataset variation of means",srt=90,col="red",cex=.7)
dev.off()
pdf("images/protruding_rim.pdf")
plotDensitiesTimeStep(aGoodOne,30000,"protruding_rim")
text(sd(tapply(emp[,"protruding_rim"],emp$site,mean))*1.08,1,"dataset variation of means",srt=90,col="red",cex=.7)
dev.off()
#######




    testMa= list(   
    verti=readFolder("testMoreAmphora/VT/"),
    horiH=readFolder("testMoreAmphora/HT/"),
    hori=readFolder("testMoreAmphora/HTD/")
    )
 
    
    testNMu= list(   
    verti=readFolder("newMutationPower//VT/"),
    horiH=readFolder("newMutationPower//HT/"),
    hori=readFolder("newMutationPower//HTD/")
    )
 
     testN10= list(   
    verti=readFolder("mutationPower10/VT/"),
    horiH=readFolder("mutationPower10//HT/"),
    hori=readFolder("mutationPower10//HTD/")
    )
 


}

getRealData <- function(emp){
    res=t(sapply(colnames(emp)[5:12],function(i)  c(mean(tapply(emp[,i],emp$site,mean)),sd(tapply(emp[,i],emp$site,mean)),min(emp[,i]),max(emp[,i]))))
    colnames(res)=c("mean of mean btw ws","sd of mean btw ws","min","max")
    return(res)
}

getRealMeasurment <- function(datafile="../data/drespaper.csv") {
    res=read.csv(datafile)
    #res=res[ res$type %in% c("Dressel D","Dressel E") ,]
    res
}

getSummaryStatistics <- function(emp,stat=mean){
    apply(emp[,5:12],2,tapply,emp$site,stat)
}

saveMeasurment <- function(){
write.csv(file="../data/mean_allmeasurment.csv",getSummaryStatistics(getRealMeasurment(),mean))
write.csv(file="../data/sd_allmeasurment.csv",getSummaryStatistics(getRealMeasurment(),sd))
write.csv(file="../data/length_allmeasurment.csv",table(getRealMeasurment()$site))
}
    #' getAllSimulationFromFolder
    #'
    #' get all tthe subfolder of a folder
    getAllSimulationFromFolder <- function(folder){
        listsubexpe=list.dirs(folder,recursive=F)
        names(listsubexpe)=basename(listsubexpe)
        return(listsubexpe)
    }


    ###Testing normal distribution assumptions
    graphAllhist <- function(){
        #pdf("../doc/distrib_allmeasurment_dresseltype.pdf",width=14,height=14)
        par(oma=rep(1,4),mar=rep(1.2,4),mfrow=c(length(unique(res$type))+1,length(colnames(res[5:12]))+1))
        sapply(c("",colnames(res)[5:12]),function(c){plot(1,1,axes=F,type="n");text(1,1,c)})
        sapply(unique(res$type),function(t){plot(1,1,axes=F,type="n");text(1,1,paste(t,"\nN=",nrow(res[res$type==t,])));sapply(5:12,function(c)mydensity(res[res$type==t,c]))})
        #dev.off()
    }

    mydensity <- function(vec){
        plot(density(vec),main="",xlab="cm",ylab="",cex=.8,axes=F)
        axis(1,cex.axis=.7,mgp=c(.3,.1,0),tck=-.02)
        cur=par()
        #text((cur$usr[1]+cur$usr[2])/2,(cur$usr[3]+cur$usr[4])/2,paste("N=",length(vec)))
    }


    tableoftest <- function(){
        library(xtable)
        library(mvn) ##mvn is awesome. But huge
        testlist=lapply(unique(res$type), function(a){ cbind(mvn(res[ res$type == a ,5:12])[["univariateNormality"]],type=a)})
        tabletest=do.call(rbind.data.frame, testlist)
        print(xtable(tabletest),include.rownames=F,file="../doc/univariate.tex")
        testlist=lapply(unique(res$type), function(a){ cbind(mvn(res[ res$type == a ,5:12])[["multivariateNormality"]],type=a)})
        tabletest=do.call(rbind.data.frame, testlist)
        print(xtable(tabletest),include.rownames=F,file="../doc/multivariate.tex")

    }
