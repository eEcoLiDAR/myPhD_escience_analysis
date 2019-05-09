library(ENMTools)

iberolacerta.clade

monticola <- iberolacerta.clade$species$monticola
cyreni <- iberolacerta.clade$species$cyreni

monticola.gam <- enmtools.gam(monticola,env=euro.worldclim,test=0.3,f=pres~bio1+bio8+bio13)
cyreni.gam <- enmtools.gam(cyreni,env=euro.worldclim,test=0.3,f=pres~bio1+bio8+bio13)

#breath
raster.breadth(monticola.gam)
raster.breadth(cyreni.gam)

monticola.gam
cyreni.gam

#niche overlap
raster.overlap(monticola.gam,cyreni.gam)

# niche identity testing
id.gam <- identity.test(cyreni,monticola,env=euro.worldclim,nreps = 20, type= "gam",f=pres~bio1+bio8+bio13)
id.gam

# background test
bg.gam <- background.test(cyreni,monticola,env=euro.worldclim,nreps=20,type="gam",f=pres~bio1+bio3+bio13,test.type = "symmetric")
bg.gam

bg.gam <- background.test(cyreni,monticola,env=euro.worldclim,nreps=20,type="gam",f=pres~bio1+bio3+bio13,test.type = "asymmetric")
bg.gam

ib.ecospat.id <- enmtools.ecospat.id(cyreni,monticola,env=euro.worldclim,nreps=100)
ib.ecospat.id

ib.ecospat.id <- enmtools.ecospat.bg(cyreni,monticola,env=euro.worldclim,nreps = 100, test.type = "symmetric")

#range breaks
ib.rangebreak <- rangebreak.linear(cyreni,monticola,env=euro.worldclim,nreps = 20,type="gam",f=pres~bio1+bio8+bio11)

ib.rangebreak <- rangebreak.blob(cyreni,monticola,env=euro.worldclim,nreps = 20,type="gam",f=pres~bio1+bio8+bio11)

# evulation
moses.list(list(monticola,cyreni), env=euro.worldclim,f=pres~poly(bio1,2)+poly(bio12,2))

ib1 <- combine.species(list(iberolacerta.clade$species$monticola,iberolacerta.clade$species$martinezricai,iberolacerta.clade$species$cyreni))
ib2 <- combine.species(list(iberolacerta.clade$species$horvathi,iberolacerta.clade$species$aurelioi,
                            iberolacerta.clade$species$aranica,iberolacerta.clade$species$bonnali))

ib.test <- moses.list(list(ib1,ib2),env=euro.worldclim,f=pres~poly(bio1,2)+poly(bio12,2))

aoc.gam <- enmtools.aoc(iberolacerta.clade,env=euro.worldclim,overlap.source = "gam",f=pres~bio1+bio12, nreps = 20)
aoc.gam

aoc.range <- enmtools.aoc(iberolacerta.clade,overlap.source = "range",nreps = 20)
aoc.range
