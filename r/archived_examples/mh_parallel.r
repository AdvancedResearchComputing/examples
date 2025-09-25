# File name: mh_parallel.r
# Description: Metropolis-Hastings using parallel library
# Run: Rscript mh_parallel.r

#Load the parallel and random number packages (and Rmpi if desired)
library(parallel)
#library(Rmpi) #uncomment to use Rmpi
library(rlecuyer)

#cluster size (from Slurm environment variable)
ncores = as.numeric(Sys.getenv("SLURM_NTASKS"))


#function to run metropolis-hastings to sample from given distribution
#using given jumping distribution
# inputs:
#   n.sims   = numer of samples
#   start    = initial draw
#   burnin   = number to discard from beginning
#   samp     = function for sample distribution
#   jump     = function for jumping distribution
#
# modified from: Lam, Patrick. "MCMC Methods: Gibbs Sampling and the Metropolis-Hastings Algorithm."
# http://patricklam.org/teaching/mcmc_print.pdf

mh <- function(n.sims, start, burnin, samp, jump) {
  theta.cur <- start
  draws <- c()

  #function to calculate a sample
  theta.update <- function(theta.cur) {
    #candidate sample
    theta.can <- jump(theta.cur)

    #acceptance probability
    accept.prob <- samp(theta.can)/samp(theta.cur)

    #compare with sample from the uniform distribution (0 to 1)
    if (runif(1) <= accept.prob)
      theta.can 
    else theta.cur
  }

  #call theta.update() n.sims times
  for (i in 1:n.sims) {
    draws[i] <- theta.cur <- theta.update(theta.cur)
  }

  #return the samples after the burn in
  return( draws[(burnin + 1):n.sims] ) 
}

#Start up and initialize the cluster
cl <- makeCluster(ncores)
#cl <- makeCluster(ncores, type = 'MPI') #uncomment to use Rmpi
clusterSetRNGStream(cl, NULL)

#define problem
samp.x = seq(0.01, 5, length=500)
samp.fcn <- function(theta) dgamma(theta, shape = 1.7, rate = 4.4)
# samp.x = seq(-4, 4, length=100)
# samp.fcn <- function(theta) dnorm(theta, mean = 0, sd = 2)
jump.fcn <- function(mean) rnorm(1, mean = mean, sd = 2)

#define MH parameters
mh.n.sims = 1e6
mh.burnin = 0

#call mh with some inputs
#mh.draws <- mh(mh.n.sims, start = 1, burnin = mh.burnin, samp = samp.fcn, jump = jump.fcn)
mh.draws.cl <- clusterCall(cl, mh, mh.n.sims, start = 1, burnin = mh.burnin, samp = samp.fcn, jump = jump.fcn)
mh.draws <- unlist(mh.draws.cl)


#plot the samples
png('mh.draws.png',type="cairo")
plot(mh.draws, main = "Sample by Iteration", xlab = "Iteration", ylab = "Samples", type="p", pch=".")
dev.off()

#get density
mh.dens <- density(mh.draws)

#get theoretical density
samp.dist <- samp.fcn(samp.x)

#plot calculated and actual densities
png('mh.draw.density.png',type="cairo")
plot(range(mh.dens$x, samp.x), range(mh.dens$y, samp.dist), type = "n", main = "Sampled vs. Actual Density", xlab = "x", ylab = "Density")
lines(mh.dens, col = "red")
lines(samp.x,samp.dist, col = "blue")
legend("topright", legend = c('Sample from MH','Actual'), col=c('red','blue'), lty=1, lwd=2)
dev.off()

#plot calculated density in groups
sample.grps = ncores
sample.grp.sz = mh.n.sims / sample.grps
png('mh.draw.prog.png',type="cairo")
plot(range(mh.dens$x), range(mh.dens$y), type = "n", main = "Density by Core", xlab = "x", ylab = "Density")
for (i in 1:sample.grps){
  dens <- density( mh.draws[((i-1)*sample.grp.sz):(i*sample.grp.sz)] )
  lines(dens, col = i)
}
legend("topright", inset=.05, legend=as.character(1:ncores), lwd=2, col=1:ncores)
dev.off()

#stop the cluster
#mpi.exit() #uncomment if using Rmpi
stopCluster(cl)
