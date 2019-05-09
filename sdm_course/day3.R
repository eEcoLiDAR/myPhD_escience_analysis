#load needed R packages, these must be previously installed via 'install.packages('packagename')

library(reshape2)
library(raster) 


# set path to your home directory that contains the downloaded files..
wdir <- "C:/Koma/Nottingham Course 2019/MultiSpTutorial-master/MultiSpTutorial-master/"

setwd(wdir)

#check
getwd()

#load data files
load("RasterAll.R")

head(rast) 
#colnames
## uniqueID = raster grid ID
## PageName = Site ID
## mammal species IDs
## lat,long,bio4,bio4future,bio12,bio12future,humanfootprint

source("FunctionsMSP.R")

plot.map("M11",rast)
plot.map("M295",rast)


# Prepare files for models-------

# subset to cells with data
dat <- rast[which(!is.na(rast$M11)),]

nrow(dat) ## should be 443880


# subset points - choose 500 presence and 500 absence of arctic fox M11

set.seed(8)
pres <- dat[sample( rownames(dat[dat$M11==1,]),size=200),]
abs <- dat[sample( rownames(dat[dat$M11==0,]),size=1000),]

arctfox <- rbind(pres,abs)

#scale enviro predictors by substracting mean and divinding by 1 st dev
arctfox$b4scale <- scale(arctfox$b4,center=T,scale=T)
arctfox$b12scale <- scale(arctfox$b12,center=T,scale=T)
arctfox$footscale <- scale(arctfox$foot,center=T,scale=T)



# run single species model with climate
mod1 <- glm(M11 ~ b4scale + b12scale + footscale, data=arctfox, family='binomial')

summary(mod1)




# run single species model with climate and presence of other species---------

# presence of competitor

mod2 <- glm(M11 ~ M295 + b4scale + b12scale + footscale, data=arctfox, family='binomial')

summary(mod2)

# presence of competitor and major prey

mod3 <- glm(M11 ~ M295 + M61 + M94 + b4scale + b12scale + footscale, data=arctfox, family='binomial')

summary(mod3)

# presence of competitor and prey as number of prey species

arctfox$NuPrey <- arctfox$M61 + arctfox$M94 + arctfox$M95 + arctfox$M31

mod4 <- glm(M11 ~ M295 + NuPrey + b4scale + b12scale + footscale, data=arctfox, family='binomial')

summary(mod4)

source("FunctionsMSP.R")

# Are other species important predictors?  Are there signs positive or negative? Is this what is expected? How do estimates of enviro effect compare between models? 

#1. typical SDM
par(mfrow=c(2,2))

m <- mod1
plotmeansCI(m=m,ylim=c(-7,7))

#2. adding competitor
m <- mod2
plotmeansCI(m=m,ylim=c(-7,7))

#3. adding competitor and prey species
m <- mod3
plotmeansCI(m=m,ylim=c(-7,7))

#4. adding competitor and prey richness
m <- mod4
plotmeansCI(m=m,ylim=c(-7,7))


## prepare data for multi-species model-----------------------------

library(lme4)
library(arm)

#make site by species matrix long-form

arctfox.multi <- melt(arctfox[,c('PageName','M295','M61','M94','M11')],id.vars=c('PageName'))


#add replicated enviro vars by number of species
arctfox.multi$b4scale <- rep(arctfox[,'b4scale'],4)
arctfox.multi$b12scale <- rep(arctfox[,'b12scale'],4)
arctfox.multi$footscale <- rep(arctfox[,'footscale'],4)

names(arctfox.multi)[1:3] <- c("Site","Species","Occur")

# random slopes and intercepts model
#mod5 <- glmer(Occur ~ b4scale + b12scale + footscale + (1 + b4scale + b12scale + footscale | Species),data=arctfox.multi,family=binomial)

# option if model doesn't converge..

mod5 <- glmer(Occur ~ b4scale + b12scale + footscale + 
                (1 + b4scale + b12scale + footscale | Species),data=arctfox.multi,family=binomial,glmerControl(optimizer="bobyqa",optCtrl=list(maxfun=2e5)))

summary(mod5)                                                                


#see slope and intercept params for each species. How do they compare to above?
coef(mod5)

m <- mod5
plotmeansCI(m=m,ylim=c(-7,7))

library(sjPlot)
#main effects log-odds scale
plot_model(m, transform = NULL)
plot_model(m, transform = "plogis")

#plot interactions
plot_model(m, type = "pred", terms = c("b12scale", "footscale"))

packages.needed <- setdiff(c('R2jags','MASS','MCMCpack','abind','random','mclust'),rownames(installed.packages()))
if(length(packages.needed)) install.packages(packages.needed)


#set input data
#here we go back to unscaled version and site x species matrix
#the code will automatically scale predictors

#how many predictors?
n_env_vars <- 3
#how many sites?
n_sites <- 7200

#input environmental predictor matrix
X <- as.matrix(arctfox[,c('b4','b12','foot')])



#test - start here
#Occur <- as.matrix(arctfox[,c('M295','M11')])

#input 
Occur <- as.matrix(arctfox[,c('M295','M61','M94','M11')])


#set up number of MCMC chains
n.chains <- 3
#number of iterations for each chain
#start at 1000 for testing
#would need 500000+ for full convergence, but ~10000 will take 2-3 minutes
n.iter <- 1000
#how many initial iterations not to include
n.burn <- 10
#how many iterations are reported
n.thin <- 100

df <- 1

#give the model a name
model_name <- 'mod6'

#this will run the model !!
source("meeRcode.R")


# check Gelman-Rubin Statistic for param convergence, should be <1.1
Diagnose(Beta,'rhat')

# plot traceplot for individual parameters
# Beta = environmental regression parameters
# Rho = residual correlation matrix


# (parameter, species #, variable #)
TPLOT(Beta, 2, 2)
# traceplot of Rho = residual correlation between species 1 and species 2
TPLOT(Rho, 1, 2)

# density plots - same order as TPLOT
#DPLOT(Beta, 2, 2)

# means of reg. params, species (rows)
BETA <- data.frame(SUMMARY(Beta,mean))
colnames(BETA) <- c("int","tempvar","precip","foot")
rownames(BETA) <- c("M295","M61","M94","M11")

SUMMARY(Beta, sd)

SUMMARY(EnvRho,mean)
SUMMARY(Rho,mean)

#prediction interval
p95 <- function(x) {quantile(x,probs=0.95)}
p5 <- function(x) {quantile(x,probs=0.05)}

#plor
mc <- SUMMARY(Beta,mean)[4,]
lo <- SUMMARY(Beta,p5)[4,]
up <- SUMMARY(Beta,p95)[4,]

plotmeansCredInt(mc,lo,up,ylim=c(-4,4))


# residual correlation
SUMMARY(Rho,mean)
SUMMARY(Rho,p5)
SUMMARY(Rho,p95)

#as.matrix(melt(SUMMARY(Rho, mean)[lower.tri(SUMMARY(Rho, mean))]))


#check enviro cor with arctic fox (M11) and others 

mc <- SUMMARY(EnvRho,mean)[1:3,4]
lo <- SUMMARY(EnvRho,p5)[1:3,4]
up <- SUMMARY(EnvRho,p95)[1:3,4]

plotmeansCredIntRho(mc,lo,up,ylim=c(-1,1))


#check residual cor with arctic fox (M11) and others 

mc <- SUMMARY(Rho,mean)[1:3,4]
lo <- SUMMARY(Rho,p5)[1:3,4]
up <- SUMMARY(Rho,p95)[1:3,4]

plotmeansCredIntRho(mc,lo,up,ylim=c(-1,1))


