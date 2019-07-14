d=seq(0,1,.001) #fake distance between 0 and oin 
#beta <- function(d,alpha)(1-(if(alpha>0)d^(100^(alpha)) else (1-(1-d)^(100^(alpha)))))
#beta <- function(d,alpha)-d^(100^(-alpha))
betaN <- function(d,alpha)((if(alpha>1)d^(100^alpha) else (1-(1-d)^(100^alpha))))
beta <- function(d,alpha)((1-(1-d)^(100^alpha))) #the last beta

betaB<- function(d,alpha)((d)^(100^alpha)) #the last beta

alphas=exp(seq(0,5,0.01))-5
alphas=c(10^(2*erf(seq(-1,1,length.out=100))))
alphas=c(10^(10*seq(-1,1,length.out=100)^3))
alphas=c(2^(10*seq(-1,1,length.out=50)))
alphaToN <- function(alpha)c(2^(10*alpha))
alphas=seq(-1,1,length.out=50)
alphas=runif(500,-1,1)
clrs=terrain.colors(length(alphas))
names(clrs)=alphas
plot(1,1,xlim=c(0,1),ylim=c(0,1),type="n",xlab="distance")
sapply(alphas,function(a)lines(d,betaN(d,-a),lwd=2,col=clrs[as.character(a)]))
par(mfrow=c(1,2))
plot(1,1,xlim=c(0,1),ylim=c(0,1),type="n",xlab=expression(d),ylab=expression(beta(d,alpha)))
sapply(alphas,function(a)lines(d,beta(d,a),lwd=2,col=clrs[as.character(a)]))
plot(1,1,xlim=c(0,1),ylim=c(0,1),type="n",xlab=expression(d),ylab=expression(betaB(d,-alpha)))
sapply(alphas,function(a)lines(d,betaB(d,-a),lwd=2,col=clrs[as.character(a)]))

sapply(alphas,function(a)lines(d,beta(d,a)-betaB(d,-a),lwd=2,col=clrs[as.character(a)]))
plot(d,beta(d,1),type="l",ylim=c(0,1))
plot(x,erf(x))
x=seq(-1,1,length.out=100)

#plot text on the graph
for(i in 1:length(alphas)){
    a=alphas[i]
    thisbeta=beta(d,a)
    #lines(d,thisbeta,lwd=2,col=clrs[as.character(a)])
    #text(i/length(alphas),1-i/length(alphas),paste("n=",round(a,digits = 2)),cex=.5)
    text(i/length(alphas),thisbeta[length(thisbeta)/2],paste("n=",round(a,digits = 2)))
}

dev.off()
pdf("../doc/beta_alpha.pdf",width=8)  
layout(t(c(1,2)),c(.8,.2))
par(mar=c(5,5,1,1),cex=1.2)
plot(1,1,xlim=c(0,1),ylim=c(0,1),type="n",xlab="d",ylab=expression(B(d,alpha)))
sapply(alphas,function(a)lines(d,betaN(d,a),lwd=2,col=clrs[as.character(a)]))
for(i in 1:length(alphas)){
    a=alphas[i]
    thisbeta=beta(.5,a)
    #text(.5,thisbeta,bquote(alpha ==.(round(a,digits = 2))),cex=.6)
}
par(mar=c(5,1,1,4))
plot(rep(1,length(alphas)),alphas,pch="_",cex=10,col=clrs[as.character(alphas)],ylab=expression(alpha),axes=F,xlab="")
axis(4,cex.ticks=.8)
mtext(expression(alpha),4,2)
mtext(expression(alpha),1,1)
#plot(rep(1,length(alphas)),1:length(alphas),pch=20,cex=10,col=clrs[as.character(alphas)])
#sapply(1:length(alphas),function(a)text(1.2,a,bquote(alpha == .(round(alphas[a],digits = 2)))))
#text(rep(1.1,length(alphas)),alphas,sapply(alphas,function(a)bquote(alpha == .(round(a,digits =2)))))
dev.off()



##simulate the probabilites to get the distrib
allprobas=matrix(nrow=length(d),ncol=length(alphas))
for(dist in 1:length(d))
    for(a in 1:length(alphas)){
        allprobas[dist,a]=sum(runif(5000) < (1-beta(d[dist],alphas[a])))/5000
    }

image(alphas,d,t(allprobas),zlim=c(0,1),col= topo.colors(120),ylab="distance",xlab=expression(alpha))


pdf("../doc/proba_map.pdf",width=8)  
layout(t(c(1,2)),c(.8,.2))
par(mar=c(5,5,1,1),cex=1.2)
image(alphas,d,t(allprobas),zlim=c(0,1),col= topo.colors(120),ylab="distance",xlab=expression(alpha))
par(mar=c(5,1,1,4))
probas=seq(0,1,length.out=120)
probalors=topo.colors(120)
names(probalors)=probas
plot(rep(1,length(probas)),probas,pch="_",cex=10,col=probalors[as.character(probas)],ylab="p",axes=F,xlab="")
axis(4)
#mtext("proba",4,2)
mtext("proba",1,1)
dev.off()
pdf("../doc/distribution_proba.pdf",width=10,height=6)
par(mfrow=c(1,3),mar=c(4,4,2,1))
plot(density(allprobas[,1:3],from=0,to=1),main=expression(alpha< (-0.9)),xlab="proba of copy")
plot(density(allprobas[,24:27],from=0,to=1),main=expression(alpha ~ 0 ),xlab="proba of copy")
plot(density(allprobas[,47:50],from=0,to=1),main=expression(alpha > (0.9)),xlab="proba of copy")
dev.off()



